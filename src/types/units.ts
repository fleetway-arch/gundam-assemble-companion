export type WeaponRange = number | 'SP';

export interface Weapon {
  name: string;
  tlCost: number;
  range: WeaponRange;
  strength: number;
  effect?: string;
  critEffect?: string;
}

export type AbilityType = 'Command' | 'Response' | 'Attack' | 'Ongoing' | 'Setup';

export interface Ability {
  name: string;
  type: AbilityType;
  requiresEnergy: boolean;
  text: string;
}

export interface Trait {
  label: string;
  value: string;
}

export interface Unit {
  id: string;
  name: string;
  cardSubtitle?: string;
  cardImageUrl?: string;
  cardTags?: string[];
  modelNumber: string;
  signatureTitle: string;
  unitCardNumber: string;
  startingTL: number;
  hitPoints: number;
  victoryPoints: number;
  massProduced: boolean;
  traits: Trait[];
  weapons: Weapon[];
  abilities: Ability[];
  signatureTactics: string;
  verified: boolean;
  custom?: boolean;
}

export interface Squad {
  id: string;
  name: string;
  targetSize: 3 | 5;
  members: string[];
}

export const ABILITY_TYPES: AbilityType[] = ['Command', 'Response', 'Attack', 'Ongoing', 'Setup'];
export const BASE_ACCURACY = 0.7;

export function expectedHits(strength: number): number {
  return Math.round(strength * BASE_ACCURACY * 100) / 100;
}

export function expectedDamagePerTL(weapon: Weapon): number {
  if (!weapon.tlCost || weapon.tlCost <= 0) return 0;
  return Math.round((expectedHits(weapon.strength) / weapon.tlCost) * 100) / 100;
}

export function bestWeaponByDPTL(unit: Unit): Weapon | null {
  return unit.weapons.reduce<Weapon | null>((best, weapon) => {
    if (!best) return weapon;
    const current = expectedDamagePerTL(weapon);
    const previous = expectedDamagePerTL(best);
    return current > previous || (current === previous && weapon.strength > best.strength)
      ? weapon
      : best;
  }, null);
}

export function rangeLabel(range: WeaponRange): string {
  return range === 'SP' ? 'SP' : String(range);
}
