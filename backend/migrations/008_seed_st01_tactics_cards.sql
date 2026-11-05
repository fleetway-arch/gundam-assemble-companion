-- ST01 tactic card pack, transcribed from the supplied card images.
INSERT OR IGNORE INTO tactics_cards (id, card) VALUES
('ST01-T05', json_object(
  'id', 'ST01-T05', 'cardNumber', 'ST01-T05', 'set', 'ST01',
  'name', 'Field Engineers', 'type', 'command', 'tlCost', 1,
  'effectText', 'Your active unit Repairs Damage 4.',
  'requiredFaction', NULL, 'signatureTitle', NULL, 'signatureUnitCardNumber', NULL,
  'source', 'Official', 'verified', json('true')
)),
('ST01-T04', json_object(
  'id', 'ST01-T04', 'cardNumber', 'ST01-T04', 'set', 'ST01',
  'name', 'Armor Shatter', 'type', 'command', 'tlCost', 1,
  'effectText', 'Your active unit Fractures an adjacent enemy unit.',
  'requiredFaction', NULL, 'signatureTitle', NULL, 'signatureUnitCardNumber', NULL,
  'source', 'Official', 'verified', json('true')
)),
('ST01-T03', json_object(
  'id', 'ST01-T03', 'cardNumber', 'ST01-T03', 'set', 'ST01',
  'name', 'Iron-Blooded Tenacity', 'type', 'response', 'tlCost', 1,
  'effectText', 'When Gundam Barbatos Lupus Rex would be defeated: Set its HP to 1 instead. It Moves 2 and makes a Rex Claws attack at Timeline 0.',
  'requiredFaction', NULL, 'signatureTitle', 'Final Stand', 'signatureUnitCardNumber', NULL,
  'source', 'Official', 'verified', json('true')
)),
('ST01-T02', json_object(
  'id', 'ST01-T02', 'cardNumber', 'ST01-T02', 'set', 'ST01',
  'name', 'Sacrificial Overload', 'type', 'response', 'tlCost', 1,
  'effectText', 'If Wing Gundam (EW) is attacked, deal Damage 2 to it and to each target.',
  'requiredFaction', NULL, 'signatureTitle', 'Wing of Destruction', 'signatureUnitCardNumber', NULL,
  'source', 'Official', 'verified', json('true')
)),
('ST01-T01', json_object(
  'id', 'ST01-T01', 'cardNumber', 'ST01-T01', 'set', 'ST01',
  'name', 'Epic Shot', 'type', 'attack', 'tlCost', 1,
  'effectText', 'Beam Rifle gains Strength +2 for each other allied unit within Range 3. Critical: Damage +2.',
  'requiredFaction', NULL, 'signatureTitle', 'Legendary Hero', 'signatureUnitCardNumber', NULL,
  'source', 'Official', 'verified', json('true')
));
