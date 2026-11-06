<script setup lang="ts">
import { computed, onMounted, ref } from 'vue';
import {
  ArrowLeft,
  Boxes,
  CheckCircle2,
  ChevronRight,
  Database,
  Monitor,
  Moon,
  Plus,
  Save,
  Shield,
  Trash2,
  Users,
  X,
  Sun,
} from 'lucide-vue-next';
import type { Squad, Unit, Weapon } from '@/types/units';
import type { SquadDeck, TacticsCard } from '@/types/tactics';
import { genId, storage } from '@/lib/storage';
import { clearAuthSession, getCurrentUser, login, signup, type AuthUser } from '@/services/auth';
import { deckRepository } from '@/services/decks';
import { tacticsRepository } from '@/services';
import { validateDeck } from '@/utils/deckValidation';

const squads = ref<Squad[]>([]);
const units = ref<Unit[]>([]);
const cards = ref<TacticsCard[]>([]);
const selectedSquadId = ref<string | null>(null);
const loading = ref(true);
const error = ref('');
const toast = ref('');
const showCreateSquad = ref(false);
const showDeck = ref(false);
const showCardPicker = ref(false);
const newSquadName = ref('');
const newSquadSize = ref<3 | 5>(3);
const unitToAdd = ref('');
const search = ref('');
const deck = ref<SquadDeck>(makeDeck(''));
type ThemeMode = 'dark' | 'light' | 'system';
const themeMode = ref<ThemeMode>('system');
const currentUser = ref<AuthUser | null>(null);
const authMode = ref<'login' | 'signup'>('login');
const authUsername = ref('');
const authEmail = ref('');
const authLogin = ref('');
const authPassword = ref('');
const authLoading = ref(false);
const authError = ref('');

const allUnits = computed(() => units.value);
const selectedSquad = computed(() => squads.value.find((s) => s.id === selectedSquadId.value) ?? null);
const squadUnits = computed(() =>
  selectedSquad.value?.members
    .map((id) => allUnits.value.find((unit) => unit.id === id))
    .filter((unit): unit is Unit => Boolean(unit)) ?? [],
);
const deckCards = computed(() =>
  deck.value.cardIds
    .map((id) => cards.value.find((card) => card.id === id))
    .filter((card): card is TacticsCard => Boolean(card)),
);
const validation = computed(() => validateDeck(deck.value, cards.value, squadUnits.value));
const filteredCards = computed(() => {
  const query = search.value.trim().toLowerCase();
  return cards.value.filter((card) => !query || `${card.name} ${card.effectText}`.toLowerCase().includes(query));
});

onMounted(() => {
  const savedTheme = window.localStorage.getItem('assemble-theme');
  if (savedTheme === 'dark' || savedTheme === 'light' || savedTheme === 'system') {
    themeMode.value = savedTheme;
  }
  currentUser.value = getCurrentUser();
  if (currentUser.value) void load();
  else loading.value = false;
});

function setTheme(mode: ThemeMode) {
  themeMode.value = mode;
  window.localStorage.setItem('assemble-theme', mode);
}

const themeIcon = computed(() => {
  if (themeMode.value === 'light') return Sun;
  if (themeMode.value === 'dark') return Moon;
  return Monitor;
});

async function load() {
  loading.value = true;
  error.value = '';
  try {
    const [loadedSquads, loadedUnits, loadedCards] = await Promise.all([
      storage.loadSquads(),
      storage.loadUnits(),
      tacticsRepository.listCards(),
    ]);
    squads.value = loadedSquads;
    units.value = loadedUnits;
    cards.value = loadedCards;
  } catch (reason) {
    error.value = reason instanceof Error ? reason.message : 'Failed to load the companion database.';
    if (error.value.includes('(401)') || error.value.toLowerCase().includes('unauthorized')) {
      logout();
    }
  } finally {
    loading.value = false;
  }
}

async function submitAuth() {
    authLoading.value = true;
    authError.value = '';
    try {
      currentUser.value = authMode.value === 'login'
        ? await login(authLogin.value, authPassword.value)
        : await signup(authUsername.value, authEmail.value, authPassword.value);
      authPassword.value = '';
      authLogin.value = '';
      authUsername.value = '';
      authEmail.value = '';
      await load();
    } catch (reason) {
      authError.value = reason instanceof Error ? reason.message : 'Authentication failed.';
    } finally {
      authLoading.value = false;
    }
}

function logout() {
    clearAuthSession();
    currentUser.value = null;
    squads.value = [];
    selectedSquadId.value = null;
    showDeck.value = false;
}

function makeDeck(squadId: string): SquadDeck {
  return { squadId, phases: 2, cardIds: [], cardUnitLinks: {} };
}

async function createSquad() {
  if (!newSquadName.value.trim()) return;
  const saved = await storage.saveSquad({
    id: genId(),
    name: newSquadName.value.trim(),
    targetSize: newSquadSize.value,
    members: [],
  });
  squads.value.push(saved);
  newSquadName.value = '';
  showCreateSquad.value = false;
  selectSquad(saved);
  notify('Team created.');
}

function selectSquad(squad: Squad) {
  selectedSquadId.value = squad.id;
  showDeck.value = false;
  void loadDeck(squad.id);
}

async function loadDeck(squadId: string) {
  deck.value = (await deckRepository.getDeck(squadId)) ?? makeDeck(squadId);
}

async function addUnit() {
  if (!selectedSquad.value || !unitToAdd.value) return;
  if (selectedSquad.value.members.includes(unitToAdd.value)) return;
  const saved = await storage.saveSquad({
    ...selectedSquad.value,
    members: [...selectedSquad.value.members, unitToAdd.value],
  });
  replaceSquad(saved);
  unitToAdd.value = '';
}

async function removeUnit(unitId: string) {
  if (!selectedSquad.value) return;
  const saved = await storage.saveSquad({
    ...selectedSquad.value,
    members: selectedSquad.value.members.filter((id) => id !== unitId),
  });
  replaceSquad(saved);
}

async function deleteSquad() {
  if (!selectedSquad.value) return;
  await storage.deleteSquad(selectedSquad.value.id);
  squads.value = squads.value.filter((squad) => squad.id !== selectedSquad.value?.id);
  selectedSquadId.value = null;
  notify('Team deleted.');
}

async function saveDeck() {
  if (!selectedSquad.value) return;
  deck.value = await deckRepository.saveDeck(selectedSquad.value.id, {
    phases: deck.value.phases,
    cardIds: deck.value.cardIds,
    cardUnitLinks: deck.value.cardUnitLinks ?? {},
  });
  notify('Deck saved to the database.');
}

function addCard(card: TacticsCard) {
  if (!deck.value.cardIds.includes(card.id)) deck.value.cardIds.push(card.id);
}

function removeCard(cardId: string) {
  deck.value.cardIds = deck.value.cardIds.filter((id) => id !== cardId);
  if (deck.value.cardUnitLinks) delete deck.value.cardUnitLinks[cardId];
}

function linkCard(cardId: string, unitId: string) {
  if (!deck.value.cardUnitLinks) deck.value.cardUnitLinks = {};
  if (unitId) deck.value.cardUnitLinks[cardId] = unitId;
  else delete deck.value.cardUnitLinks[cardId];
}

function replaceSquad(saved: Squad) {
  const index = squads.value.findIndex((squad) => squad.id === saved.id);
  if (index >= 0) squads.value[index] = saved;
}

function notify(message: string) {
  toast.value = message;
  window.setTimeout(() => {
    if (toast.value === message) toast.value = '';
  }, 2500);
}

function weaponLabel(weapon: Weapon) {
  return `${weapon.name} · TL ${weapon.tlCost} · RNG ${weapon.range} · STR ${weapon.strength}`;
}

function readValue(event: Event) {
  return (event.target as HTMLSelectElement | HTMLInputElement).value;
}
</script>

<template>
  <div class="min-h-screen flex flex-col" :data-theme="themeMode">
    <header class="sticky top-0 z-40 border-b-2 border-oxblood-600 bg-base-900/95 backdrop-blur-md">
      <div class="max-w-6xl mx-auto px-4 h-14 flex items-center justify-between">
        <button class="flex items-center gap-2.5 text-left" @click="selectedSquadId = null">
          <span class="w-9 h-9 border border-oxblood-400 bg-oxblood-700/40 flex items-center justify-center shadow-glow-orange">
            <Shield :size="20" class="text-cyan-glow" />
          </span>
          <span class="leading-none">
            <strong class="block text-cream tracking-[0.24em] text-sm">ASSEMBLE</strong>
            <small class="text-[10px] text-cyan-glow/80 tracking-[0.3em] uppercase font-mono">Companion // VUE</small>
          </span>
        </button>
        <nav v-if="currentUser" class="hidden sm:flex items-center gap-1">
          <span class="px-3 py-1.5 text-cream bg-oxblood-600 border border-oxblood-400 text-sm flex items-center gap-1.5">
            <Users :size="16" /> My Squads
          </span>
          <span class="px-3 py-1.5 text-slate-600 text-sm flex items-center gap-1.5">
            <Boxes :size="16" /> Unit Database <small>soon</small>
          </span>
          <label class="theme-picker ml-2" title="Color theme">
            <component :is="themeIcon" :size="15" />
            <select v-model="themeMode" @change="setTheme(themeMode)" aria-label="Color theme">
              <option value="system">System</option>
              <option value="dark">Dark</option>
              <option value="light">Light</option>
            </select>
          </label>
          <span class="ml-2 text-xs text-slate-400">{{ currentUser.username }}</span>
          <button class="btn-ghost text-xs" @click="logout">Log out</button>
        </nav>
        <div v-if="currentUser" class="flex items-center gap-2 sm:hidden">
          <span class="text-xs text-slate-400">{{ currentUser.username }}</span>
          <button class="btn-ghost text-xs" @click="logout">Log out</button>
        </div>
        <label v-if="currentUser" class="theme-picker sm:hidden" title="Color theme">
          <component :is="themeIcon" :size="15" />
          <select v-model="themeMode" @change="setTheme(themeMode)" aria-label="Color theme">
            <option value="system">System</option>
            <option value="dark">Dark</option>
            <option value="light">Light</option>
          </select>
        </label>
      </div>
    </header>

    <main class="flex-1 max-w-6xl w-full mx-auto px-4 py-6">
      <div v-if="!currentUser" class="max-w-md mx-auto mt-8 hud-panel hud-edge p-6">
        <div class="text-center mb-6">
          <Shield :size="30" class="mx-auto mb-3 text-cyan-glow" />
          <p class="stat-label text-cyan-glow">Command // Access</p>
          <h1 class="text-2xl font-bold text-cream">{{ authMode === 'login' ? 'Welcome back, pilot' : 'Create your pilot account' }}</h1>
        </div>
        <form class="space-y-4" @submit.prevent="submitAuth">
          <input v-if="authMode === 'signup'" v-model="authUsername" class="input" required minlength="3" maxlength="32" autocomplete="username" placeholder="Username" />
          <input v-if="authMode === 'signup'" v-model="authEmail" class="input" required type="email" autocomplete="email" placeholder="Email" />
          <input v-if="authMode === 'login'" v-model="authLogin" class="input" required autocomplete="username" placeholder="Username or email" />
          <input v-model="authPassword" class="input" required minlength="8" maxlength="128" type="password" autocomplete="current-password" placeholder="Password" />
          <p v-if="authError" class="text-sm text-red-200">{{ authError }}</p>
          <button class="btn-primary w-full" :disabled="authLoading">
            {{ authLoading ? 'Connecting…' : authMode === 'login' ? 'Log in' : 'Sign up' }}
          </button>
        </form>
        <button class="btn-ghost w-full mt-3" @click="authMode = authMode === 'login' ? 'signup' : 'login'; authError = ''">
          {{ authMode === 'login' ? 'Need an account? Sign up' : 'Already registered? Log in' }}
        </button>
      </div>

      <template v-else>
      <div v-if="loading" class="hud-panel p-8 text-center text-slate-400">Loading companion database…</div>
      <div v-else-if="error" class="hud-panel-orange p-5 text-red-100">{{ error }}</div>

      <template v-else-if="!selectedSquad">
        <div class="flex items-center justify-between gap-3 mb-5">
          <div>
            <p class="stat-label text-cyan-glow">Command // Teams</p>
            <h1 class="text-3xl font-bold text-cream tracking-wide">My Squads</h1>
          </div>
          <button class="btn-primary" @click="showCreateSquad = true"><Plus :size="16" /> Create Team</button>
        </div>
        <div v-if="!squads.length" class="hud-panel p-10 text-center">
          <Users :size="30" class="mx-auto mb-3 text-cyan-glow" />
          <p class="text-slate-300 mb-4">No teams have been created yet.</p>
          <button class="btn-primary" @click="showCreateSquad = true">Create your first team</button>
        </div>
        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
          <button v-for="squad in squads" :key="squad.id" class="hud-panel hud-edge p-5 text-left hover:border-oxblood-400 transition" @click="selectSquad(squad)">
            <div class="flex items-start justify-between gap-3">
              <div>
                <p class="stat-label">Team roster</p>
                <h2 class="text-xl font-bold text-cream mt-1">{{ squad.name }}</h2>
              </div>
              <ChevronRight class="text-cyan-glow" />
            </div>
            <p class="mt-4 text-sm text-slate-400">{{ squad.members.length }} / {{ squad.targetSize }} units assigned</p>
          </button>
        </div>
      </template>

      <template v-else>
        <div class="flex items-center gap-2 flex-wrap mb-5">
          <button class="btn-ghost !px-2" @click="selectedSquadId = null"><ArrowLeft :size="18" /></button>
          <div class="flex-1">
            <p class="stat-label text-cyan-glow">Team // {{ selectedSquad.members.length }} / {{ selectedSquad.targetSize }}</p>
            <h1 class="text-2xl font-bold text-cream">{{ selectedSquad.name }}</h1>
          </div>
          <button class="btn-danger text-xs" @click="deleteSquad"><Trash2 :size="14" /> Delete</button>
          <button class="btn-primary text-sm" @click="showDeck = !showDeck"><Database :size="15" /> {{ showDeck ? 'Hide Deck' : 'Build Deck' }}</button>
        </div>

        <section class="hud-panel hud-edge p-4 mb-5">
          <div class="flex items-center justify-between gap-2 mb-3">
            <h2 class="text-sm font-bold uppercase tracking-wider text-slate-300">Units</h2>
            <div class="flex gap-2">
              <select v-model="unitToAdd" class="input !w-auto text-xs">
                <option value="">Add existing unit…</option>
                <option v-for="unit in allUnits.filter((candidate) => !selectedSquad.members.includes(candidate.id))" :key="unit.id" :value="unit.id">{{ unit.name }}</option>
              </select>
              <button class="btn-primary text-xs" :disabled="!unitToAdd" @click="addUnit">Assign</button>
            </div>
          </div>
          <div v-if="!squadUnits.length" class="py-8 text-center text-sm text-slate-500">No units assigned.</div>
          <div class="grid grid-cols-1 md:grid-cols-2 gap-3">
            <article v-for="unit in squadUnits" :key="unit.id" class="unit-card">
              <div class="unit-card-header">
                <div>
                  <p>{{ unit.modelNumber }} · {{ unit.unitCardNumber }}</p>
                  <h3>{{ unit.name }}</h3>
                  <small v-if="unit.cardSubtitle">{{ unit.cardSubtitle }}</small>
                </div>
                <button class="unit-card-remove" @click="removeUnit(unit.id)"><X :size="15" /></button>
              </div>
              <div class="unit-card-stats px-4 py-2"><strong>HP {{ unit.hitPoints }}</strong><strong>VP {{ unit.victoryPoints }}</strong><strong>TL {{ unit.startingTL }}</strong></div>
              <div class="unit-card-traits"><span v-for="trait in unit.traits" :key="trait.label">{{ trait.value || trait.label }}</span></div>
              <div class="p-3 text-xs text-slate-400 space-y-1">
                <p v-for="weapon in unit.weapons" :key="weapon.name">{{ weaponLabel(weapon) }}</p>
                <p v-for="ability in unit.abilities" :key="ability.name"><strong class="text-cream">{{ ability.name }}</strong> · {{ ability.text }}</p>
              </div>
            </article>
          </div>
          </section>

        <Transition name="fade">
          <section v-if="showDeck" class="space-y-4">
          <div class="flex items-center justify-between">
            <div><h2 class="text-lg font-bold text-cream">Tactics Deck</h2><p class="text-xs text-slate-500">Each card can link to one squad unit for future limitations.</p></div>
            <button class="btn-primary" @click="saveDeck"><Save :size="15" /> Save Deck</button>
          </div>
          <div class="hud-panel hud-edge p-4">
            <div class="flex items-center justify-between">
              <span class="font-mono text-cream">{{ deck.cardIds.length }} / {{ validation.requiredSize }} cards</span>
              <span v-if="validation.valid" class="text-emerald-300 text-xs flex items-center gap-1"><CheckCircle2 :size="14" /> Valid</span>
              <span v-else class="text-orange-200 text-xs">{{ validation.errors[0]?.message }}</span>
            </div>
            <div class="mt-3 flex items-center gap-2 text-xs">
              <span class="stat-label">Phases</span>
              <button v-for="phase in [2, 3, 4]" :key="phase" class="px-2 py-1 border" :class="deck.phases === phase ? 'border-cyan-glow bg-cyan-glow/15 text-cyan-glow' : 'border-base-600 text-slate-400'" @click="deck.phases = phase">{{ phase }}</button>
              <button class="btn-primary text-xs ml-auto" @click="showCardPicker = true"><Plus :size="14" /> Add cards</button>
            </div>
          </div>
          <div class="hud-panel p-4 space-y-2">
            <p v-if="!deckCards.length" class="text-center text-sm text-slate-500 py-5">No cards in this deck yet.</p>
            <div v-for="card in deckCards" :key="card.id" class="border border-slate-600/70 p-3 flex items-start gap-3">
              <div class="flex-1"><strong class="text-cream">{{ card.name }}</strong><p class="text-xs text-slate-400 mt-1">{{ card.effectText }}</p></div>
              <select class="input !w-auto text-xs" :value="deck.cardUnitLinks?.[card.id] ?? ''" @change="linkCard(card.id, readValue($event))">
                <option value="">No unit link</option><option v-for="unit in squadUnits" :key="unit.id" :value="unit.id">{{ unit.name }}</option>
              </select>
              <button class="btn-ghost !px-1" @click="removeCard(card.id)"><Trash2 :size="14" /></button>
            </div>
          </div>
        </section>
        </Transition>
      </template>
      </template>
    </main>

    <footer class="border-t border-oxblood-600/60 py-3 text-center text-[11px] text-slate-500 font-mono uppercase tracking-wider">
      Gundam Assemble Companion // Vue frontend // Unofficial fan tool
    </footer>

    <Transition name="modal">
      <div v-if="showCreateSquad" class="fixed inset-0 z-50 bg-black/70 flex items-center justify-center p-4" @click.self="showCreateSquad = false">
      <form class="hud-panel p-5 w-full max-w-md space-y-4" @submit.prevent="createSquad">
        <div class="flex justify-between"><h2 class="text-lg font-bold text-cream">Create Team</h2><button type="button" class="btn-ghost !px-1" @click="showCreateSquad = false"><X :size="16" /></button></div>
        <input v-model="newSquadName" class="input" placeholder="Team name" autofocus />
        <label class="text-xs text-slate-400">Target size <select v-model.number="newSquadSize" class="input mt-1"><option :value="3">3 units</option><option :value="5">5 units</option></select></label>
        <button class="btn-primary w-full">Create Team</button>
      </form>
      </div>
    </Transition>

    <Transition name="modal">
      <div v-if="showCardPicker" class="fixed inset-0 z-50 bg-black/70 flex items-center justify-center p-4" @click.self="showCardPicker = false">
      <div class="hud-panel p-5 w-full max-w-4xl max-h-[85vh] overflow-auto space-y-4">
        <div class="flex justify-between"><h2 class="text-lg font-bold text-cream">Add Tactics Cards</h2><button class="btn-ghost !px-1" @click="showCardPicker = false"><X :size="16" /></button></div>
        <input v-model="search" class="input" placeholder="Search cards…" />
        <div class="grid sm:grid-cols-2 gap-3">
          <article v-for="card in filteredCards" :key="card.id" class="hud-panel p-3">
            <div class="flex justify-between gap-2"><strong class="text-cream">{{ card.name }}</strong><span class="chip border-cyan-glow/30 text-cyan-200">{{ card.type }}</span></div>
            <p class="text-xs text-slate-400 mt-2">{{ card.effectText }}</p>
            <button class="btn-primary text-xs w-full mt-3" :disabled="deck.cardIds.includes(card.id)" @click="addCard(card)">{{ deck.cardIds.includes(card.id) ? 'Added' : 'Add to deck' }}</button>
          </article>
        </div>
      </div>
      </div>
    </Transition>

    <Transition name="fade">
      <div v-if="toast" class="fixed bottom-5 right-5 z-[60] hud-panel-orange px-4 py-3 text-sm text-cream">{{ toast }}</div>
    </Transition>
  </div>
</template>
