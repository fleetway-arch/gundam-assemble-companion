CREATE TABLE IF NOT EXISTS tactics_cards (
  id TEXT PRIMARY KEY NOT NULL,
  card TEXT NOT NULL CHECK (json_valid(card)),
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Tactic cards transcribed from the supplied PA01, EX01, and EX02 card images.
INSERT OR IGNORE INTO tactics_cards (id, card) VALUES
('EX02-T09', json_object(
  'id', 'EX02-T09', 'cardNumber', 'EX02-T09', 'set', 'EX02',
  'name', 'Interception', 'type', 'response', 'tlCost', 1,
  'effectText', 'An allied unit gains Challenge this attack. (If this unit is not defending, swap it with a defending ally within Range 2. This unit becomes the defender.)',
  'requiredFaction', NULL, 'signatureTitle', 'Asticassia', 'signatureUnitCardNumber', NULL,
  'source', 'Official', 'verified', json('true')
)),
('EX02-T08', json_object(
  'id', 'EX02-T08', 'cardNumber', 'EX02-T08', 'set', 'EX02',
  'name', 'Linked Strike', 'type', 'response', 'tlCost', 1,
  'effectText', 'The attacker gains Strength +3 this attack and an additional Strength +1 for each allied RWS adjacent to the target.',
  'requiredFaction', NULL, 'signatureTitle', 'Asticassia', 'signatureUnitCardNumber', NULL,
  'source', 'Official', 'verified', json('true')
)),
('EX02-T07', json_object(
  'id', 'EX02-T07', 'cardNumber', 'EX02-T07', 'set', 'EX02',
  'name', 'BIT Shield', 'type', 'response', 'tlCost', 1,
  'effectText', 'A defender is dealt Damage -3 this attack and an additional Damage -1 for each allied RWS within Range 2.',
  'requiredFaction', NULL, 'signatureTitle', 'Asticassia', 'signatureUnitCardNumber', NULL,
  'source', 'Official', 'verified', json('true')
)),
('EX02-T06', json_object(
  'id', 'EX02-T06', 'cardNumber', 'EX02-T06', 'set', 'EX02',
  'name', 'Interference Pattern', 'type', 'command', 'tlCost', 1,
  'effectText', 'Your active Asticassia unit applies Disarm to each enemy unit within Range 3.',
  'requiredFaction', NULL, 'signatureTitle', 'Asticassia', 'signatureUnitCardNumber', NULL,
  'source', 'Official', 'verified', json('true')
)),
('EX02-T05', json_object(
  'id', 'EX02-T05', 'cardNumber', 'EX02-T05', 'set', 'EX02',
  'name', 'Drone Assault', 'type', 'command', 'tlCost', 1,
  'effectText', 'Each allied RWS deals Damage 1 to an adjacent enemy.',
  'requiredFaction', NULL, 'signatureTitle', 'Asticassia', 'signatureUnitCardNumber', NULL,
  'source', 'Official', 'verified', json('true')
)),
('EX02-T04', json_object(
  'id', 'EX02-T04', 'cardNumber', 'EX02-T04', 'set', 'EX02',
  'name', 'Dismantle', 'type', 'command', 'tlCost', 1,
  'effectText', 'Your active unit destroys all Upgrades on an enemy unit adjacent to an allied RWS.',
  'requiredFaction', NULL, 'signatureTitle', 'Asticassia', 'signatureUnitCardNumber', NULL,
  'source', 'Official', 'verified', json('true')
)),
('EX02-T03', json_object(
  'id', 'EX02-T03', 'cardNumber', 'EX02-T03', 'set', 'EX02',
  'name', 'Isvara Assault', 'type', 'command', 'tlCost', 1,
  'effectText', 'Reposition Darilbalde to a hex adjacent to its Isvara B Type. Darilbalde''s attacks deal Damage +2 this activation.',
  'requiredFaction', NULL, 'signatureTitle', 'Frontline Duelist', 'signatureUnitCardNumber', NULL,
  'source', 'Official', 'verified', json('true')
)),
('EX02-T02', json_object(
  'id', 'EX02-T02', 'cardNumber', 'EX02-T02', 'set', 'EX02',
  'name', 'Cold Silence', 'type', 'command', 'tlCost', 1,
  'effectText', 'All enemy units adjacent to Gundam Pharact''s Corax move up 1 Timeline.',
  'requiredFaction', NULL, 'signatureTitle', 'Silent Hunter', 'signatureUnitCardNumber', NULL,
  'source', 'Official', 'verified', json('true')
)),
('EX02-T01', json_object(
  'id', 'EX02-T01', 'cardNumber', 'EX02-T01', 'set', 'EX02',
  'name', 'Bit Assault', 'type', 'command', 'tlCost', 1,
  'effectText', 'Gundam Aerial repositions all ally and enemy Remote Weapon Systems onto any empty hexes on the battlefield. Each RWS deals Damage 1 to an enemy unit adjacent to it.',
  'requiredFaction', NULL, 'signatureTitle', 'Protective Heroine', 'signatureUnitCardNumber', NULL,
  'source', 'Official', 'verified', json('true')
)),
('EX01-T09', json_object(
  'id', 'EX01-T09', 'cardNumber', 'EX01-T09', 'set', 'EX01',
  'name', 'Grunt''s Guard', 'type', 'response', 'tlCost', 1,
  'effectText', 'A defender is dealt Damage -4 this attack if it is worth less VP than the attacker.',
  'requiredFaction', NULL, 'signatureTitle', NULL, 'signatureUnitCardNumber', NULL,
  'source', 'Official', 'verified', json('true')
)),
('EX01-T08', json_object(
  'id', 'EX01-T08', 'cardNumber', 'EX01-T08', 'set', 'EX01',
  'name', 'Target Reacquisition', 'type', 'response', 'tlCost', 1,
  'effectText', 'Reroll any number of misses. If you reroll 3 or more misses, draw 1 card.',
  'requiredFaction', NULL, 'signatureTitle', 'Londo Bell', 'signatureUnitCardNumber', NULL,
  'source', 'Official', 'verified', json('true')
)),
('EX01-T07', json_object(
  'id', 'EX01-T07', 'cardNumber', 'EX01-T07', 'set', 'EX01',
  'name', 'Special OPs', 'type', 'command', 'tlCost', 1,
  'effectText', 'Up to three of your Londo Bell units on the battlefield gain 1 different Upgrade of your choice.',
  'requiredFaction', NULL, 'signatureTitle', 'Londo Bell', 'signatureUnitCardNumber', NULL,
  'source', 'Official', 'verified', json('true')
)),
('EX01-T06', json_object(
  'id', 'EX01-T06', 'cardNumber', 'EX01-T06', 'set', 'EX01',
  'name', 'Salvage Systems', 'type', 'command', 'tlCost', 1,
  'effectText', 'Your active unit Repairs Damage 3. Then, if it has full HP, it gains Energy 1.',
  'requiredFaction', NULL, 'signatureTitle', 'Londo Bell', 'signatureUnitCardNumber', NULL,
  'source', 'Official', 'verified', json('true')
)),
('EX01-T05', json_object(
  'id', 'EX01-T05', 'cardNumber', 'EX01-T05', 'set', 'EX01',
  'name', 'On-Site Integration', 'type', 'command', 'tlCost', 1,
  'effectText', 'Your active unit gains 1 Upgrade of your choice.',
  'requiredFaction', NULL, 'signatureTitle', 'Londo Bell', 'signatureUnitCardNumber', NULL,
  'source', 'Official', 'verified', json('true')
)),
('EX01-T04', json_object(
  'id', 'EX01-T04', 'cardNumber', 'EX01-T04', 'set', 'EX01',
  'name', 'Full System Burn', 'type', 'command', 'tlCost', 1,
  'effectText', 'Your active Londo Bell unit gains Speed +3 and Hover this activation.',
  'requiredFaction', NULL, 'signatureTitle', 'Londo Bell', 'signatureUnitCardNumber', NULL,
  'source', 'Official', 'verified', json('true')
)),
('EX01-T03', json_object(
  'id', 'EX01-T03', 'cardNumber', 'EX01-T03', 'set', 'EX01',
  'name', 'Swift Appropriation', 'type', 'command', 'tlCost', 1,
  'effectText', 'Delta Plus takes Energy 1 and 1 Upgrade from a unit within Range 3.',
  'requiredFaction', NULL, 'signatureTitle', 'Rapid Response', 'signatureUnitCardNumber', NULL,
  'source', 'Official', 'verified', json('true')
)),
('EX01-T02', json_object(
  'id', 'EX01-T02', 'cardNumber', 'EX01-T02', 'set', 'EX01',
  'name', 'Critical Rescue', 'type', 'command', 'tlCost', 1,
  'effectText', 'Torohachi Moves 5. After it ends its movement, it Rescues each allied Garrison it moved adjacent to.',
  'requiredFaction', NULL, 'signatureTitle', 'Petite Mobile Suit', 'signatureUnitCardNumber', NULL,
  'source', 'Official', 'verified', json('true')
)),
('EX01-T01', json_object(
  'id', 'EX01-T01', 'cardNumber', 'EX01-T01', 'set', 'EX01',
  'name', 'Psycho-Frame Overload', 'type', 'command', 'tlCost', 1,
  'effectText', 'Unicorn Gundam deals Damage equal to the number of Upgrades on it to an enemy within Range 2.',
  'requiredFaction', NULL, 'signatureTitle', 'Laplace''s Guardian', 'signatureUnitCardNumber', NULL,
  'source', 'Official', 'verified', json('true')
)),
('PA01-T09', json_object(
  'id', 'PA01-T09', 'cardNumber', 'PA01-T09', 'set', 'PA01',
  'name', 'Interference', 'type', 'response', 'tlCost', 1,
  'effectText', 'The attacker gets Accuracy -2 this attack.',
  'requiredFaction', NULL, 'signatureTitle', NULL, 'signatureUnitCardNumber', NULL,
  'source', 'Official', 'verified', json('true')
)),
('PA01-T08', json_object(
  'id', 'PA01-T08', 'cardNumber', 'PA01-T08', 'set', 'PA01',
  'name', 'Counter Attack', 'type', 'response', 'tlCost', 1,
  'effectText', 'If the allied defender survives, it makes an attack against the attacking enemy unit at Timeline -1.',
  'requiredFaction', NULL, 'signatureTitle', NULL, 'signatureUnitCardNumber', NULL,
  'source', 'Official', 'verified', json('true')
));
