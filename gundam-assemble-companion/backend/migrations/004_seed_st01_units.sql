-- ST01 unit card data supplied by the user.
-- Source: supplied unit card images; data remains unverified until reviewed.

INSERT OR IGNORE INTO units (id, unit) VALUES
('unit-gundam-st01', json_object(
  'id', 'unit-gundam-st01', 'name', 'Gundam', 'cardSubtitle', 'Legendary Hero',
  'cardImageUrl', '', 'cardTags', json_array('Legendary Hero', 'Amuro Ray', 'Earth Federation'),
  'modelNumber', 'RX-78-2', 'signatureTitle', 'Gundam', 'unitCardNumber', 'ST01-U001',
  'startingTL', 2, 'hitPoints', 15, 'victoryPoints', 8, 'massProduced', json('false'),
  'traits', json_array(
    json_object('label', 'Title', 'value', 'Legendary Hero'),
    json_object('label', 'Pilot', 'value', 'Amuro Ray'),
    json_object('label', 'Faction', 'value', 'Earth Federation')
  ),
  'weapons', json_array(
    json_object('name', 'Vulcan Guns', 'tlCost', 2, 'range', 2, 'strength', 3, 'effect', '', 'critEffect', 'Roll 2 additional dice.'),
    json_object('name', 'Beam Saber', 'tlCost', 3, 'range', 1, 'strength', 6, 'effect', 'After Attack Roll, Deactivate all Shield Upgrades on the target.', 'critEffect', 'Damage +2.')
  ),
  'abilities', json_array(
    json_object('name', 'Frenzied Charge', 'type', 'Command', 'requiresEnergy', json('true'), 'text', 'Move 2. Beam Saber gains Strength +1 this activation for each Garrison you''ve Rescued.'),
    json_object('name', 'Escape from Side 7', 'type', 'Response', 'requiresEnergy', json('false'), 'text', 'After this unit Rescues a Garrison: Gain 1 Energy.')
  ),
  'signatureTactics', '', 'verified', json('false'), 'custom', json('false')
)),
('unit-gundam-barbatos-lupus-rex', json_object(
  'id', 'unit-gundam-barbatos-lupus-rex', 'name', 'Gundam Barbatos Lupus Rex', 'cardSubtitle', 'Final Stand',
  'cardImageUrl', '', 'cardTags', json_array('Final Stand', 'Mikazuki Augus', 'Tekkadan'),
  'modelNumber', 'ASW-G-08', 'signatureTitle', 'Gundam Barbatos Lupus Rex', 'unitCardNumber', 'ST01-U003',
  'startingTL', 2, 'hitPoints', 17, 'victoryPoints', 10, 'massProduced', json('false'),
  'traits', json_array(
    json_object('label', 'Title', 'value', 'Final Stand'),
    json_object('label', 'Pilot', 'value', 'Mikazuki Augus'),
    json_object('label', 'Faction', 'value', 'Tekkadan')
  ),
  'weapons', json_array(
    json_object('name', 'Rex Claws', 'tlCost', 2, 'range', 1, 'strength', 3, 'effect', '', 'critEffect', 'Slow the target.'),
    json_object('name', 'Tail Blade', 'tlCost', 4, 'range', 2, 'strength', 7, 'effect', 'Before Attack Roll, Pull 1 the target.', 'critEffect', 'Damage +1.')
  ),
  'abilities', json_array(
    json_object('name', 'Annihilate', 'type', 'Command', 'requiresEnergy', json('true'), 'text', 'If this unit made a Tail Blade attack this activation, it makes an additional Rex Claws attack at Timeline 0.'),
    json_object('name', 'Alaya-Vijnana Exertion', 'type', 'Command', 'requiresEnergy', json('false'), 'text', 'Deal Damage 3 to this unit. Move 2.'),
    json_object('name', 'Fight to the End', 'type', 'Ongoing', 'requiresEnergy', json('false'), 'text', 'While this unit has: 6 or more Damage: Its attacks gain Strength +1. 12 or more Damage: Its attacks gain an additional Strength +1.')
  ),
  'signatureTactics', '', 'verified', json('false'), 'custom', json('false')
)),
('unit-chars-zaku-ii', json_object(
  'id', 'unit-chars-zaku-ii', 'name', 'Char''s Zaku II', 'cardSubtitle', 'Fast Encounter',
  'cardImageUrl', '', 'cardTags', json_array('Fast Encounter', 'Char Aznable', 'Zeon'),
  'modelNumber', 'MS-06S', 'signatureTitle', 'Char''s Zaku II', 'unitCardNumber', 'ST01-U004',
  'startingTL', 2, 'hitPoints', 12, 'victoryPoints', 7, 'massProduced', json('false'),
  'traits', json_array(
    json_object('label', 'Title', 'value', 'Fast Encounter'),
    json_object('label', 'Pilot', 'value', 'Char Aznable'),
    json_object('label', 'Faction', 'value', 'Zeon')
  ),
  'weapons', json_array(
    json_object('name', 'Heat Hawk', 'tlCost', 2, 'range', 1, 'strength', 4, 'effect', '', 'critEffect', 'After Combat Damage, Fracture the target.'),
    json_object('name', 'Zaku Bazooka', 'tlCost', 4, 'range', 4, 'strength', 7, 'effect', 'After Combat Damage, Make an additional Dash at Timeline 0.', 'critEffect', 'Damage +2.')
  ),
  'abilities', json_array(
    json_object('name', 'Checkmate', 'type', 'Command', 'requiresEnergy', json('true'), 'text', 'This unit''s attacks gain Accuracy +2 and After Attack Roll Destroy 1 Upgrade on the target this activation.'),
    json_object('name', 'Three-Times Faster', 'type', 'Ongoing', 'requiresEnergy', json('false'), 'text', 'This unit Moves 1 additional hex when Dashing.'),
    json_object('name', 'Char Kick', 'type', 'Response', 'requiresEnergy', json('false'), 'text', 'After this unit Dashes: It deals Damage 1 to an adjacent enemy.')
  ),
  'signatureTactics', '', 'verified', json('false'), 'custom', json('false')
)),
('unit-gundam-epyon-ew', json_object(
  'id', 'unit-gundam-epyon-ew', 'name', 'Gundam Epyon (EW)', 'cardSubtitle', 'Crimson Cataclysm',
  'cardImageUrl', '', 'cardTags', json_array('Crimson Cataclysm', 'Zechs Merquise', 'White Fang', 'OZ'),
  'modelNumber', 'OZ-13MS', 'signatureTitle', 'Gundam Epyon (EW)', 'unitCardNumber', 'ST01-U005',
  'startingTL', 3, 'hitPoints', 15, 'victoryPoints', 9, 'massProduced', json('false'),
  'traits', json_array(
    json_object('label', 'Title', 'value', 'Crimson Cataclysm'),
    json_object('label', 'Pilot', 'value', 'Zechs Merquise'),
    json_object('label', 'Faction', 'value', 'White Fang'),
    json_object('label', 'Faction', 'value', 'OZ')
  ),
  'weapons', json_array(
    json_object('name', 'Heat Rod', 'tlCost', 2, 'range', 2, 'strength', 3, 'effect', 'Before Attack Roll, Pull 1 the target.', 'critEffect', 'Disarm the target.'),
    json_object('name', 'Beam Sword', 'tlCost', 3, 'range', 1, 'strength', 7, 'effect', '', 'critEffect', 'Damage +1.')
  ),
  'abilities', json_array(
    json_object('name', 'No Escape', 'type', 'Command', 'requiresEnergy', json('true'), 'text', 'Slow an enemy unit within Range 2.'),
    json_object('name', 'Exploit Weakness', 'type', 'Ongoing', 'requiresEnergy', json('false'), 'text', 'This unit''s attacks gain Strength +2 against enemies with status effects.'),
    json_object('name', 'Hover', 'type', 'Ongoing', 'requiresEnergy', json('false'), 'text', 'This unit ignores terrain movement penalties.')
  ),
  'signatureTactics', '', 'verified', json('false'), 'custom', json('false')
));
