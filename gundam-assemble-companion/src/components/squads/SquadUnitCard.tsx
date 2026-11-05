import type { Unit } from '@/types/units';
import { rangeLabel } from '@/types/units';
import { Copy, Plus, X } from 'lucide-react';

interface SquadUnitCardProps {
  unit: Unit;
  onClick?: () => void;
  onRemove?: () => void;
  compact?: boolean;
}

export function SquadUnitCard({ unit, onClick, onRemove }: SquadUnitCardProps) {
  const attacks = unit.weapons.slice(0, 2);

  return (
    <article className="unit-card" onClick={onClick}>
      <header className="unit-card-header">
        <div>
          <div className="unit-card-stats">
            <strong>HP {unit.hitPoints}</strong>
            <strong>VP {unit.victoryPoints}</strong>
            <strong>TL {unit.startingTL}</strong>
          </div>
          <h3>{unit.name}</h3>
          <p>{unit.modelNumber} · {unit.unitCardNumber}</p>
        </div>
        {onRemove && (
          <button className="unit-card-remove" onClick={(event) => {
            event.stopPropagation();
            onRemove();
          }} aria-label={`Remove ${unit.name}`}>
            <X size={15} />
          </button>
        )}
      </header>

      <div className="unit-card-traits">
        {unit.traits.slice(0, 3).map((trait) => (
          <span key={`${trait.label}-${trait.value}`}>{trait.value}</span>
        ))}
        {unit.massProduced && <Copy size={12} aria-label="Mass produced" />}
      </div>

      <div className="unit-card-attacks">
        {attacks.map((weapon) => (
          <section key={weapon.name} className="unit-attack">
            <h4>{weapon.name}</h4>
            <div className="unit-attack-fields">
              <span>TL <b>{weapon.tlCost}</b></span>
              <span>RNG <b>{rangeLabel(weapon.range)}</b></span>
              <span>STR <b>{weapon.strength}</b></span>
            </div>
            {weapon.critEffect && <p><b>Critical:</b> {weapon.critEffect}</p>}
            {weapon.effect && <p>{weapon.effect}</p>}
          </section>
        ))}
      </div>

      {unit.abilities.length > 0 && (
        <footer className="unit-card-effects">
          {unit.abilities.slice(0, 3).map((ability) => (
            <p key={ability.name}><b>{ability.name}</b> {ability.text}</p>
          ))}
        </footer>
      )}
    </article>
  );
}
