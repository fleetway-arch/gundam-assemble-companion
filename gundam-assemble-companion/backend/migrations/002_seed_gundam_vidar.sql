-- Gundam Vidar unit card
-- Source: supplied unit card image; data is unverified until reviewed.

INSERT OR IGNORE INTO units (id, unit) VALUES (
  'unit-gundam-vidar',
  json_object(
    'id', 'unit-gundam-vidar',
    'name', 'Gundam Vidar',
    'cardSubtitle', 'Cold Justice',
    'cardImageUrl', '',
    'cardTags', json_array('Cold Justice', 'Vidar', 'Gjallarhorn'),
    'modelNumber', 'ASW-G-XX',
    'signatureTitle', 'Vidar',
    'unitCardNumber', 'ST01-006',
    'startingTL', 1,
    'hitPoints', 13,
    'victoryPoints', 7,
    'massProduced', json('false'),
    'traits', json_array(
      json_object('label', 'Title', 'value', 'Cold Justice'),
      json_object('label', 'Pilot', 'value', 'Vidar'),
      json_object('label', 'Faction', 'value', 'Gjallarhorn')
    ),
    'weapons', json_array(
      json_object(
        'name', 'Handguns',
        'tlCost', 2,
        'range', 3,
        'strength', 3,
        'effect', '',
        'critEffect', 'After Combat Damage, repeat this attack at Timeline 0 without this ability.'
      ),
      json_object(
        'name', 'Burst Saber',
        'tlCost', 1,
        'range', 4,
        'strength', 8,
        'effect', '',
        'critEffect', 'Damage +2.'
      )
    ),
    'abilities', json_array(
      json_object(
        'name', 'Hunter''s Edge',
        'type', 'Command',
        'requiresEnergy', json('true'),
        'text', 'Push 2 an adjacent enemy and deal Damage 1 to it.'
      ),
      json_object(
        'name', 'Alaya-Vijnana Type E System',
        'type', 'Command',
        'requiresEnergy', json('false'),
        'text', 'If you control 2 or more Objectives, Move 2 and this unit gains Strength +1 this activation.'
      )
    ),
    'signatureTactics', '',
    'verified', json('false'),
    'custom', json('false')
  )
);
