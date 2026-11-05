import type { Weapon } from '@/types/units';
import { expectedHits, expectedDamagePerTL, rangeLabel } from '@/types/units';
import { Crosshair, Zap } from 'lucide-react';

export function WeaponRow({ weapon, showComputed = true }: { weapon: Weapon; showComputed?: boolean }) {
  const dmg = expectedHits(weapon.strength);
  const dptl = expectedDamagePerTL(weapon);
  return (
    <div className="border-l-2 border-cyan-glow/30 pl-3 py-1.5">
      <div className="flex items-center justify-between gap-2 flex-wrap">
        <span className="font-semibold text-slate-100 text-sm">{weapon.name}</span>
        <div className="flex items-center gap-1.5 text-[11px] font-mono text-slate-400">
          <span className="chip border-cyan-glow/30 bg-cyan-glow/5 text-cyan-200">
            TL {weapon.tlCost}
          </span>
          <span className="chip border-orange-glow/30 bg-orange-glow/5 text-orange-200">
            RNG {rangeLabel(weapon.range)}
          </span>
          <span className="chip border-slate-500/30 bg-slate-700/40 text-slate-200">
            STR {weapon.strength}
          </span>
        </div>
      </div>
      {(weapon.effect || weapon.critEffect) && (
        <div className="mt-1 text-[11px] text-slate-400 flex flex-wrap gap-x-3 gap-y-0.5">
          {weapon.effect && <span>Effect: {weapon.effect}</span>}
          {weapon.critEffect && <span className="text-orange-200">Crit: {weapon.critEffect}</span>}
        </div>
      )}
      {showComputed && (
        <div className="mt-1.5 flex flex-wrap gap-2 text-[11px] font-mono">
          <span className="inline-flex items-center gap-1 text-cyan-200">
            <Crosshair size={12} /> E[dmg] {dmg.toFixed(2)}
          </span>
          <span className="inline-flex items-center gap-1 text-orange-200">
            <Zap size={12} /> E[dmg]/TL {dptl.toFixed(2)}
          </span>
        </div>
      )}
    </div>
  );
}
