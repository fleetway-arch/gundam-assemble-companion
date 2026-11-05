-- Supplied unit card data for PA01, EX01, and EX02.
-- Source: supplied unit card images; data remains unverified until reviewed.

INSERT OR IGNORE INTO units (id, unit) VALUES
('unit-gundam', json_object(
  'id', 'unit-gundam', 'name', 'Gundam', 'cardSubtitle', 'Elite Mobile Suit',
  'cardImageUrl', '', 'cardTags', json_array('Elite Mobile Suit', 'Amuro Ray', 'Earth Federation'),
  'modelNumber', 'RX-78-2', 'signatureTitle', 'Gundam', 'unitCardNumber', 'PA01-U001',
  'startingTL', 1, 'hitPoints', 17, 'victoryPoints', 10, 'massProduced', json('false'),
  'traits', json_array(json_object('label', 'Title', 'value', 'Elite Mobile Suit'), json_object('label', 'Pilot', 'value', 'Amuro Ray'), json_object('label', 'Faction', 'value', 'Earth Federation')),
  'weapons', json_array(
    json_object('name', 'Beam Saber', 'tlCost', 2, 'range', 1, 'strength', 3, 'effect', '', 'critEffect', 'After Combat Damage, Fracture the target.'),
    json_object('name', 'Beam Rifle', 'tlCost', 3, 'range', 3, 'strength', 5, 'effect', '', 'critEffect', 'Disarm the target.')
  ),
  'abilities', json_array(
    json_object('name', 'Toss Away', 'type', 'Response', 'requiresEnergy', json('true'), 'text', 'Before Attack Roll, if this unit is attacking, it Pushes 2 the target.'),
    json_object('name', 'Inspiring Presence', 'type', 'Response', 'requiresEnergy', json('false'), 'text', 'After Attack Roll, if another allied unit within Range 2 is attacking, reroll up to 3 misses.'),
    json_object('name', 'Challenge', 'type', 'Response', 'requiresEnergy', json('false'), 'text', 'Before Attack Roll, if this unit is not defending, swap it with a defending ally within Range 2.')
  ),
  'signatureTactics', '', 'verified', json('false'), 'custom', json('false')
)),
('unit-guncannon', json_object(
  'id', 'unit-guncannon', 'name', 'Guncannon', 'cardSubtitle', 'In Position',
  'cardImageUrl', '', 'cardTags', json_array('In Position', 'Kai Shiden', 'Earth Federation'),
  'modelNumber', 'RX-77-2', 'signatureTitle', 'Guncannon', 'unitCardNumber', 'PA01-U002',
  'startingTL', 2, 'hitPoints', 12, 'victoryPoints', 7, 'massProduced', json('false'),
  'traits', json_array(json_object('label', 'Title', 'value', 'In Position'), json_object('label', 'Pilot', 'value', 'Kai Shiden'), json_object('label', 'Faction', 'value', 'Earth Federation')),
  'weapons', json_array(
    json_object('name', '240mm Low-Recoil Cannon', 'tlCost', 2, 'range', 'SP', 'strength', 3, 'effect', '', 'critEffect', 'After Combat Damage, Fracture the target.'),
    json_object('name', 'Beam Rifle', 'tlCost', 4, 'range', 4, 'strength', 7, 'effect', 'This attack also targets each enemy adjacent to the target.', 'critEffect', 'Damage +1.')
  ),
  'abilities', json_array(
    json_object('name', 'Stunning Shot', 'type', 'Response', 'requiresEnergy', json('true'), 'text', 'After Combat Damage, if this unit attacked, each target moves 1 Timeline.'),
    json_object('name', 'Firing Line', 'type', 'Ongoing', 'requiresEnergy', json('false'), 'text', 'If this unit has not moved this activation, its attacks gain Accuracy +1 and Strength +1.'),
    json_object('name', 'Challenge', 'type', 'Response', 'requiresEnergy', json('false'), 'text', 'Before Attack Roll, if this unit is not defending, swap it with a defending ally within Range 2.')
  ),
  'signatureTactics', '', 'verified', json('false'), 'custom', json('false')
)),
('unit-guntank', json_object(
  'id', 'unit-guntank', 'name', 'Guntank', 'cardSubtitle', 'Battlefield Bombarder',
  'cardImageUrl', '', 'cardTags', json_array('Battlefield Bombarder', 'Hayato Kobayashi', 'Earth Federation'),
  'modelNumber', 'RX-75', 'signatureTitle', 'Guntank', 'unitCardNumber', 'PA01-U003',
  'startingTL', 2, 'hitPoints', 13, 'victoryPoints', 7, 'massProduced', json('false'),
  'traits', json_array(json_object('label', 'Title', 'value', 'Battlefield Bombarder'), json_object('label', 'Pilot', 'value', 'Hayato Kobayashi'), json_object('label', 'Faction', 'value', 'Earth Federation')),
  'weapons', json_array(
    json_object('name', '120mm Low-Recoil Cannons', 'tlCost', 2, 'range', 4, 'strength', 2, 'effect', 'This attack ignores Line of Sight.', 'critEffect', 'Disarm the target.'),
    json_object('name', 'Quadruple Bop Missile', 'tlCost', 3, 'range', 'SP', 'strength', 5, 'effect', '', 'critEffect', 'Damage +1.')
  ),
  'abilities', json_array(
    json_object('name', 'Coordinated Payload', 'type', 'Response', 'requiresEnergy', json('true'), 'text', 'Before Attack Roll, if this unit is attacking, it gains Strength +1 for each other allied unit within Range 3.'),
    json_object('name', 'Crowd Control', 'type', 'Response', 'requiresEnergy', json('false'), 'text', 'After Combat Damage, if this unit dealt Damage 2 or more to enemies this attack, draw 1 card.')
  ),
  'signatureTactics', '', 'verified', json('false'), 'custom', json('false')
)),
('unit-unicorn-gundam-destroy-mode', json_object(
  'id', 'unit-unicorn-gundam-destroy-mode', 'name', 'Unicorn Gundam (Destroy Mode)', 'cardSubtitle', 'Laplace''s Guardian',
  'cardImageUrl', '', 'cardTags', json_array('Laplace''s Guardian', 'Banagher Links', 'Civilian', 'Earth Federation', 'Londo Bell'),
  'modelNumber', 'RX-0', 'signatureTitle', 'Unicorn Gundam (Destroy Mode)', 'unitCardNumber', 'EX01-U001',
  'startingTL', 3, 'hitPoints', 14, 'victoryPoints', 10, 'massProduced', json('false'),
  'traits', json_array(json_object('label', 'Title', 'value', 'Laplace''s Guardian'), json_object('label', 'Pilot', 'value', 'Banagher Links'), json_object('label', 'Faction', 'value', 'Civilian'), json_object('label', 'Faction', 'value', 'Earth Federation'), json_object('label', 'Faction', 'value', 'Londo Bell')),
  'weapons', json_array(
    json_object('name', 'Beam Saber', 'tlCost', 2, 'range', 1, 'strength', 4, 'effect', '', 'critEffect', 'After Combat Damage, gain 1 Strength Upgrade.'),
    json_object('name', 'Beam Magnum', 'tlCost', 4, 'range', 4, 'strength', 8, 'effect', '', 'critEffect', 'Damage +1 for each Upgrade on this unit (max. 4).')
  ),
  'abilities', json_array(
    json_object('name', 'Psycho-Frame Synchrony', 'type', 'Response', 'requiresEnergy', json('true'), 'text', 'Before Attack Roll, another attacker within Range 3 gets Strength +1 for each Strength +1 Upgrade on this unit.'),
    json_object('name', 'Newtype Destroyer', 'type', 'Ongoing', 'requiresEnergy', json('false'), 'text', 'Enemies can''t use Response abilities while this unit is attacking or being attacked.')
  ),
  'signatureTactics', '', 'verified', json('false'), 'custom', json('false')
)),
('unit-torohachi', json_object(
  'id', 'unit-torohachi', 'name', 'Torohachi', 'cardSubtitle', 'Petite Mobile Suit',
  'cardImageUrl', '', 'cardTags', json_array('Petite Mobile Suit', 'Civilian', 'Earth Federation', 'Mass Produced'),
  'modelNumber', 'TOLRO-800', 'signatureTitle', 'Torohachi', 'unitCardNumber', 'EX01-U002',
  'startingTL', 1, 'hitPoints', 8, 'victoryPoints', 5, 'massProduced', json('true'),
  'traits', json_array(json_object('label', 'Title', 'value', 'Petite Mobile Suit'), json_object('label', 'Faction', 'value', 'Civilian'), json_object('label', 'Faction', 'value', 'Earth Federation'), json_object('label', 'Trait', 'value', 'Mass Produced')),
  'weapons', json_array(json_object('name', 'Armored Frame', 'tlCost', 2, 'range', 1, 'strength', 3, 'effect', '', 'critEffect', 'Damage +1 for each Shield Upgrade on this unit (max. +4).')),
  'abilities', json_array(
    json_object('name', 'Rescue Maneuver', 'type', 'Command', 'requiresEnergy', json('true'), 'text', 'Rescue an allied Garrison within Range 3.'),
    json_object('name', 'Supply', 'type', 'Response', 'requiresEnergy', json('false'), 'text', 'After this unit Rescues a Garrison, gain 1 Shield Upgrade.'),
    json_object('name', 'Material Transfer', 'type', 'Command', 'requiresEnergy', json('false'), 'text', 'Redistribute Upgrades among this unit and another allied unit within Range 3.')
  ),
  'signatureTactics', '', 'verified', json('false'), 'custom', json('false')
)),
('unit-delta-plus', json_object(
  'id', 'unit-delta-plus', 'name', 'Delta Plus', 'cardSubtitle', 'Rapid Response',
  'cardImageUrl', '', 'cardTags', json_array('Rapid Response', 'Riddhe Marcenas', 'Earth Federation', 'Londo Bell'),
  'modelNumber', 'MSN-001A1', 'signatureTitle', 'Delta Plus', 'unitCardNumber', 'EX01-U003',
  'startingTL', 2, 'hitPoints', 11, 'victoryPoints', 7, 'massProduced', json('false'),
  'traits', json_array(json_object('label', 'Title', 'value', 'Rapid Response'), json_object('label', 'Pilot', 'value', 'Riddhe Marcenas'), json_object('label', 'Faction', 'value', 'Earth Federation'), json_object('label', 'Faction', 'value', 'Londo Bell')),
  'weapons', json_array(
    json_object('name', 'Twin-Barreled Grenade Launcher', 'tlCost', 2, 'range', 3, 'strength', 3, 'effect', '', 'critEffect', 'Slow the target.'),
    json_object('name', 'Beam Rifle', 'tlCost', 4, 'range', 5, 'strength', 6, 'effect', 'Strength +1 for each Speed Upgrade on this unit.', 'critEffect', 'Gain 1 Speed Upgrade.')
  ),
  'abilities', json_array(
    json_object('name', 'Blitzing Slash', 'type', 'Response', 'requiresEnergy', json('true'), 'text', 'After this unit ends its movement, it deals Damage 1 to each enemy it moved adjacent to.'),
    json_object('name', 'Jet Through', 'type', 'Ongoing', 'requiresEnergy', json('false'), 'text', 'While this unit has at least 1 Speed Upgrade, it has Hover.')
  ),
  'signatureTactics', '', 'verified', json('false'), 'custom', json('false')
)),
('unit-gundam-aerial', json_object(
  'id', 'unit-gundam-aerial', 'name', 'Gundam Aerial', 'cardSubtitle', 'Protective Heroine',
  'cardImageUrl', '', 'cardTags', json_array('Protective Heroine', 'Suletta Mercury', 'Asticassia'),
  'modelNumber', 'XVX-016', 'signatureTitle', 'Gundam Aerial', 'unitCardNumber', 'EX02-U001',
  'startingTL', 1, 'hitPoints', 16, 'victoryPoints', 10, 'massProduced', json('false'),
  'traits', json_array(json_object('label', 'Title', 'value', 'Protective Heroine'), json_object('label', 'Pilot', 'value', 'Suletta Mercury'), json_object('label', 'Faction', 'value', 'Asticassia')),
  'weapons', json_array(
    json_object('name', 'Beam Sabers', 'tlCost', 2, 'range', 1, 'strength', 3, 'effect', '', 'critEffect', 'After Combat Damage, repeat this attack at Timeline 0 without this ability.'),
    json_object('name', 'Beam Rifle', 'tlCost', 4, 'range', 4, 'strength', 6, 'effect', 'Strength +1 for each allied RWS adjacent to the target.', 'critEffect', 'Damage +2.')
  ),
  'abilities', json_array(
    json_object('name', 'Permet Burst', 'type', 'Response', 'requiresEnergy', json('true'), 'text', 'After Attack Roll, if this unit or another allied unit within Range 3 is attacking, set 1 die to Critical.'),
    json_object('name', 'BIT Stave Direct', 'type', 'Command', 'requiresEnergy', json('false'), 'text', 'Deploy or reposition this unit''s BIT Stave Type on an empty hex within Range 3.'),
    json_object('name', 'Challenge', 'type', 'Response', 'requiresEnergy', json('false'), 'text', 'Before Attack Roll, if this unit is not defending, swap it with a defending ally within Range 2.')
  ),
  'signatureTactics', '', 'verified', json('false'), 'custom', json('false')
)),
('unit-gundam-pharact', json_object(
  'id', 'unit-gundam-pharact', 'name', 'Gundam Pharact', 'cardSubtitle', 'Silent Hunter',
  'cardImageUrl', '', 'cardTags', json_array('Silent Hunter', 'Elan Ceres', 'Asticassia'),
  'modelNumber', 'FP/A-77', 'signatureTitle', 'Gundam Pharact', 'unitCardNumber', 'EX02-U002',
  'startingTL', 2, 'hitPoints', 12, 'victoryPoints', 7, 'massProduced', json('false'),
  'traits', json_array(json_object('label', 'Title', 'value', 'Silent Hunter'), json_object('label', 'Pilot', 'value', 'Elan Ceres'), json_object('label', 'Faction', 'value', 'Asticassia')),
  'weapons', json_array(
    json_object('name', 'Beak Foot', 'tlCost', 2, 'range', 3, 'strength', 3, 'effect', '', 'critEffect', 'Roll 2 additional dice.'),
    json_object('name', 'Beam Arquebus', 'tlCost', 4, 'range', 5, 'strength', 6, 'effect', 'After Attack Roll, Deactivate all Shield Upgrades on the target.', 'critEffect', 'After Combat Damage, this unit Moves 2, ignoring Engagement.')
  ),
  'abilities', json_array(
    json_object('name', 'Lockdown', 'type', 'Response', 'requiresEnergy', json('true'), 'text', 'After Combat Damage, if this unit is attacked by an enemy adjacent to this unit''s Corax, it applies Slow to that enemy unit.'),
    json_object('name', 'Corax Direct', 'type', 'Command', 'requiresEnergy', json('false'), 'text', 'Deploy or reposition this unit''s Corax on an empty hex within Range 4.'),
    json_object('name', 'Hover', 'type', 'Ongoing', 'requiresEnergy', json('false'), 'text', 'This unit ignores terrain movement penalties.')
  ),
  'signatureTactics', '', 'verified', json('false'), 'custom', json('false')
)),
('unit-darilbalde', json_object(
  'id', 'unit-darilbalde', 'name', 'Darilbalde', 'cardSubtitle', 'Frontline Duelist',
  'cardImageUrl', '', 'cardTags', json_array('Frontline Duelist', 'Guel Jeturk', 'Asticassia'),
  'modelNumber', 'MD-0064', 'signatureTitle', 'Darilbalde', 'unitCardNumber', 'EX02-U003',
  'startingTL', 3, 'hitPoints', 13, 'victoryPoints', 8, 'massProduced', json('false'),
  'traits', json_array(json_object('label', 'Title', 'value', 'Frontline Duelist'), json_object('label', 'Pilot', 'value', 'Guel Jeturk'), json_object('label', 'Faction', 'value', 'Asticassia')),
  'weapons', json_array(
    json_object('name', 'Shackle Claw', 'tlCost', 2, 'range', 2, 'strength', 4, 'effect', 'After Attack Roll, Move 1 towards the target ignoring terrain penalties.', 'critEffect', 'Disarm the target.'),
    json_object('name', 'Beam Saber', 'tlCost', 3, 'range', 1, 'strength', 7, 'effect', '', 'critEffect', 'Deal Damage 2 to each enemy adjacent to this unit''s Isvara B Type.')
  ),
  'abilities', json_array(
    json_object('name', 'Sundering Strike', 'type', 'Command', 'requiresEnergy', json('true'), 'text', 'Fracture an adjacent enemy unit.'),
    json_object('name', 'Isvara B Type Direct', 'type', 'Command', 'requiresEnergy', json('false'), 'text', 'Deploy or reposition this unit''s Isvara B Type on an empty hex within Range 2.')
  ),
  'signatureTactics', '', 'verified', json('false'), 'custom', json('false')
));
