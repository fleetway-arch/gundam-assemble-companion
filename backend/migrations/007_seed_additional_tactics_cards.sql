-- Legacy additional tactic cards transcribed from the supplied PA01 and ST01 card images.
-- New set updates are kept in their own migration pack.
INSERT OR IGNORE INTO tactics_cards (id, card) VALUES
('PA01-T07', json_object(
  'id', 'PA01-T07', 'cardNumber', 'PA01-T07', 'set', 'PA01',
  'name', 'Systematic Elimination', 'type', 'response', 'tlCost', 1,
  'effectText', 'If you''ve defeated 3 or more Garrison, the attacker gains Strength +4 this attack.',
  'requiredFaction', NULL, 'signatureTitle', NULL, 'signatureUnitCardNumber', NULL,
  'source', 'Official', 'verified', json('true')
)),
('PA01-T06', json_object(
  'id', 'PA01-T06', 'cardNumber', 'PA01-T06', 'set', 'PA01',
  'name', 'Breaker Sweep', 'type', 'command', 'tlCost', 1,
  'effectText', 'Your active unit destroys up to 2 Upgrades on an enemy unit within Range 2.',
  'requiredFaction', NULL, 'signatureTitle', NULL, 'signatureUnitCardNumber', NULL,
  'source', 'Official', 'verified', json('true')
)),
('PA01-T05', json_object(
  'id', 'PA01-T05', 'cardNumber', 'PA01-T05', 'set', 'PA01',
  'name', 'Sayla''s Encouragement', 'type', 'response', 'tlCost', 1,
  'effectText', 'After an allied unit is dealt Damage, it gains Energy 2.',
  'requiredFaction', 'Earth Federation', 'signatureTitle', NULL, 'signatureUnitCardNumber', NULL,
  'source', 'Official', 'verified', json('true')
)),
('PA01-T04', json_object(
  'id', 'PA01-T04', 'cardNumber', 'PA01-T04', 'set', 'PA01',
  'name', 'Formative Strength', 'type', 'response', 'tlCost', 1,
  'effectText', 'The attacker gains Accuracy +2 and Strength +1 this attack if it is within Range 3 of another allied unit.',
  'requiredFaction', 'Earth Federation', 'signatureTitle', NULL, 'signatureUnitCardNumber', NULL,
  'source', 'Official', 'verified', json('true')
)),
('PA01-T03', json_object(
  'id', 'PA01-T03', 'cardNumber', 'PA01-T03', 'set', 'PA01',
  'name', 'Bulwark Siege', 'type', 'command', 'tlCost', 1,
  'effectText', 'Guntank Moves 2. Then, it applies Fracture to each enemy unit within Range 2.',
  'requiredFaction', NULL, 'signatureTitle', 'Battlefield Bombarder', 'signatureUnitCardNumber', NULL,
  'source', 'Official', 'verified', json('true')
)),
('PA01-T02', json_object(
  'id', 'PA01-T02', 'cardNumber', 'PA01-T02', 'set', 'PA01',
  'name', 'All In', 'type', 'command', 'tlCost', 1,
  'effectText', 'Guncannon makes an additional 240mm Low-Recoil Cannon attack at Timeline 0.',
  'requiredFaction', NULL, 'signatureTitle', 'In Position', 'signatureUnitCardNumber', NULL,
  'source', 'Official', 'verified', json('true')
)),
('PA01-T01', json_object(
  'id', 'PA01-T01', 'cardNumber', 'PA01-T01', 'set', 'PA01',
  'name', 'Protective Shot', 'type', 'response', 'tlCost', 1,
  'effectText', 'After an enemy ends its movement within Range 3 of you, Guncannon immediately makes a Beam Rifle attack at Timeline 1 against it.',
  'requiredFaction', NULL, 'signatureTitle', 'Elite Mobile Suit', 'signatureUnitCardNumber', NULL,
  'source', 'Official', 'verified', json('true')
)),
('ST01-T18', json_object(
  'id', 'ST01-T18', 'cardNumber', 'ST01-T18', 'set', 'ST01',
  'name', 'Strikethrough', 'type', 'response', 'tlCost', 1,
  'effectText', 'This attack deals Damage +1.',
  'requiredFaction', NULL, 'signatureTitle', NULL, 'signatureUnitCardNumber', NULL,
  'source', 'Official', 'verified', json('true')
)),
('ST01-T17', json_object(
  'id', 'ST01-T17', 'cardNumber', 'ST01-T17', 'set', 'ST01',
  'name', 'Neutralize', 'type', 'response', 'tlCost', 1,
  'effectText', 'A defender is dealt Damage -2 this attack and destroys 1 Upgrade on the attacker.',
  'requiredFaction', NULL, 'signatureTitle', NULL, 'signatureUnitCardNumber', NULL,
  'source', 'Official', 'verified', json('true')
)),
('ST01-T16', json_object(
  'id', 'ST01-T16', 'cardNumber', 'ST01-T16', 'set', 'ST01',
  'name', 'Limiter Release', 'type', 'response', 'tlCost', 1,
  'effectText', 'The attacker gains Strength +3 this attack.',
  'requiredFaction', NULL, 'signatureTitle', NULL, 'signatureUnitCardNumber', NULL,
  'source', 'Official', 'verified', json('true')
)),
('ST01-T15', json_object(
  'id', 'ST01-T15', 'cardNumber', 'ST01-T15', 'set', 'ST01',
  'name', 'Renewed Power', 'type', 'command', 'tlCost', 1,
  'effectText', 'Your active unit gains 1 Strength Upgrade.',
  'requiredFaction', NULL, 'signatureTitle', NULL, 'signatureUnitCardNumber', NULL,
  'source', 'Official', 'verified', json('true')
)),
('ST01-T14', json_object(
  'id', 'ST01-T14', 'cardNumber', 'ST01-T14', 'set', 'ST01',
  'name', 'Ghost Step', 'type', 'command', 'tlCost', 1,
  'effectText', 'Your active unit Moves 2.',
  'requiredFaction', NULL, 'signatureTitle', NULL, 'signatureUnitCardNumber', NULL,
  'source', 'Official', 'verified', json('true')
)),
('ST01-T13', json_object(
  'id', 'ST01-T13', 'cardNumber', 'ST01-T13', 'set', 'ST01',
  'name', 'Armor Upgrade', 'type', 'command', 'tlCost', 1,
  'effectText', 'Your active unit gains 1 Shield Upgrade.',
  'requiredFaction', NULL, 'signatureTitle', NULL, 'signatureUnitCardNumber', NULL,
  'source', 'Official', 'verified', json('true')
)),
('ST01-T12', json_object(
  'id', 'ST01-T12', 'cardNumber', 'ST01-T12', 'set', 'ST01',
  'name', 'Claiming Vengeance', 'type', 'attack', 'tlCost', 1,
  'effectText', 'After Attack Roll, Capture an Objective the target is on or adjacent to.',
  'requiredFaction', NULL, 'signatureTitle', 'Cold Justice', 'signatureUnitCardNumber', NULL,
  'source', 'Official', 'verified', json('true')
)),
('ST01-T11', json_object(
  'id', 'ST01-T11', 'cardNumber', 'ST01-T11', 'set', 'ST01',
  'name', 'War Edge', 'type', 'attack', 'tlCost', 1,
  'effectText', 'This attack deals Damage +1 on a Critical hit.',
  'requiredFaction', NULL, 'signatureTitle', 'Crimson Cataclysm', 'signatureUnitCardNumber', NULL,
  'source', 'Official', 'verified', json('true')
)),
('ST01-T10', json_object(
  'id', 'ST01-T10', 'cardNumber', 'ST01-T10', 'set', 'ST01',
  'name', 'Crimson Execution', 'type', 'command', 'tlCost', 1,
  'effectText', 'Char''s Zaku II makes an additional Dash at Timeline 0. Then, it makes an additional Heat Hawk attack at Timeline 0.',
  'requiredFaction', NULL, 'signatureTitle', 'Fast Encounter', 'signatureUnitCardNumber', NULL,
  'source', 'Official', 'verified', json('true')
)),
('ST01-T09', json_object(
  'id', 'ST01-T09', 'cardNumber', 'ST01-T09', 'set', 'ST01',
  'name', 'Quick Block', 'type', 'response', 'tlCost', 1,
  'effectText', 'A defender is dealt Damage -3 this attack.',
  'requiredFaction', NULL, 'signatureTitle', NULL, 'signatureUnitCardNumber', NULL,
  'source', 'Official', 'verified', json('true')
)),
('ST01-T08', json_object(
  'id', 'ST01-T08', 'cardNumber', 'ST01-T08', 'set', 'ST01',
  'name', 'Breaking Blow', 'type', 'response', 'tlCost', 1,
  'effectText', 'The attacker gains Strength +2 this attack. Destroy 1 Upgrade on each of the targets.',
  'requiredFaction', NULL, 'signatureTitle', NULL, 'signatureUnitCardNumber', NULL,
  'source', 'Official', 'verified', json('true')
)),
('ST01-T07', json_object(
  'id', 'ST01-T07', 'cardNumber', 'ST01-T07', 'set', 'ST01',
  'name', 'Thrust Boosters', 'type', 'command', 'tlCost', 1,
  'effectText', 'Your active unit gains 1 Speed Upgrade.',
  'requiredFaction', NULL, 'signatureTitle', NULL, 'signatureUnitCardNumber', NULL,
  'source', 'Official', 'verified', json('true')
)),
('ST01-T06', json_object(
  'id', 'ST01-T06', 'cardNumber', 'ST01-T06', 'set', 'ST01',
  'name', 'Hero''s Might', 'type', 'command', 'tlCost', 1,
  'effectText', 'If you''ve Rescued 3 or more Garrisons, your active unit gains Energy 2.',
  'requiredFaction', NULL, 'signatureTitle', NULL, 'signatureUnitCardNumber', NULL,
  'source', 'Official', 'verified', json('true')
));
