module hexbound;              
import std::io;
import raylib5::rl;
import std::math;

const int SCREEN_WIDTH = 1080;
const int SCREEN_HEIGHT = 800;
const int FPS = 30;
const int SIMULATED_FPS = 1;

// Basic character attributes
struct Attribute 
{
    String name;
    int value;
    int modifier;
}

// An ability granted by a deity
struct Ability 
{
    String name;
    String description;
    int power_level;
    String deity_source;
}

// A deity that can be worshipped
struct Deity 
{
    String name;
    String domain;
    String description;
    Ability* granted_abilities;
    rl::Color theme_color;
}

// The player character
struct Character 
{
    String name;
    Attribute attributes;
    Deity* worshipped_deities;
    Ability* abilities;
    int health;
    int mana;
    
    // Character appearance
    int skin_tone;
    int hair_style;
    int face_style;
}

// Game state management
enum GameScreen 
{
    TITLE,
    CHARACTER_CREATION,
    DEITY_SELECTION,
    ABILITY_SELECTION,
    CHARACTER_SHEET,
    GAME_WORLD
}

struct GameState 
{
    GameScreen current_screen;
    Character player;
    Deity* available_deities;
    int selected_deity_index;
}

// Create a new character with default attributes
fn Character createNewCharacter() 
{
    Character character;
    character.name = "Unnamed Hero";
    character.health = 100;
    character.mana = 50;
    character.skin_tone = 0;
    character.hair_style = 0;
    character.face_style = 0;
    
    // Initialize basic attributes
    Attribute strength;
    strength.name = "Strength";
    strength.value = 10;
    strength.modifier = 0;
    character.attributes += strength;
    
    Attribute dexterity;
    dexterity.name = "Dexterity";
    dexterity.value = 10;
    dexterity.modifier = 0;
    character.attributes.push_back(dexterity);
    
    Attribute constitution;
    constitution.name = "Constitution";
    constitution.value = 10;
    constitution.modifier = 0;
    character.attributes.push_back(constitution);
    
    Attribute intelligence;
    intelligence.name = "Intelligence";
    intelligence.value = 10;
    intelligence.modifier = 0;
    character.attributes.push_back(intelligence);
    
    Attribute wisdom;
    wisdom.name = "Wisdom";
    wisdom.value = 10;
    wisdom.modifier = 0;
    character.attributes.push_back(wisdom);
    
    Attribute charisma;
    charisma.name = "Charisma";
    charisma.value = 10;
    charisma.modifier = 0;
    character.attributes.push_back(charisma);
    
    return character;
}

// Initialize the deities and their abilities with occult themes
fn Deity* initDeities()
{
    Deity[*] deities;
    
    // The Hierophant - occult knowledge and revelation
    Deity hierophant;
    hierophant.name = "The Hierophant";
    hierophant.domain = "Hidden Knowledge, Rituals, and Enlightenment";
    hierophant.description = "The enigmatic keeper of occult wisdom who reveals secrets to the worthy.";
    hierophant.theme_color = rl::GOLD;
    
    Ability hierophant_ability1;
    hierophant_ability1.name = "Third Eye Awakening";
    hierophant_ability1.description = "Temporarily open your third eye to perceive hidden truths and auras.";
    hierophant_ability1.power_level = 3;
    hierophant_ability1.deity_source = "The Hierophant";
    
    Ability hierophant_ability2;
    hierophant_ability2.name = "Ritual of Revelation";
    hierophant_ability2.description = "Perform a complex ritual that reveals invisible entities and concealed magic.";
    hierophant_ability2.power_level = 4;
    hierophant_ability2.deity_source = "The Hierophant";
    
    hierophant.granted_abilities.push_back(hierophant_ability1);
    hierophant.granted_abilities.push_back(hierophant_ability2);
    
    // The Hermit - astral projection and dimensional travel
    Deity hermit;
    hermit.name = "The Hermit";
    hermit.domain = "Astral Planes, Solitude, and Inner Journeys";
    hermit.description = "The solitary wanderer between worlds who grants powers of spiritual travel.";
    hermit.theme_color = rl::SKYBLUE;
    
    Ability hermit_ability1;
    hermit_ability1.name = "Astral Projection";
    hermit_ability1.description = "Separate your consciousness from your body to travel the astral planes.";
    hermit_ability1.power_level = 4;
    hermit_ability1.deity_source = "The Hermit";
    
    Ability hermit_ability2;
    hermit_ability2.name = "Psychic Refuge";
    hermit_ability2.description = "Create a mental sanctuary that shields your mind from psychic intrusions.";
    hermit_ability2.power_level = 3;
    hermit_ability2.deity_source = "The Hermit";
    
    hermit.granted_abilities.push_back(hermit_ability1);
    hermit.granted_abilities.push_back(hermit_ability2);
    
    // The Hanged Man - sacrifice and binding magic
    Deity hanged_man;
    hanged_man.name = "The Hanged Man";
    hanged_man.domain = "Sacrifice, Binding, and Suspended Animation";
    hanged_man.description = "The suspended entity who grants power through sacrifice and binding rituals.";
    hanged_man.theme_color = rl::DARKBLUE;
    
    Ability hanged_man_ability1;
    hanged_man_ability1.name = "Blood Pact";
    hanged_man_ability1.description = "Sacrifice vitality to create a powerful binding contract with another entity.";
    hanged_man_ability1.power_level = 5;
    hanged_man_ability1.deity_source = "The Hanged Man";
    
    Ability hanged_man_ability2;
    hanged_man_ability2.name = "Suspend Essence";
    hanged_man_ability2.description = "Place yourself or target in a state of suspended animation, halting all effects.";
    hanged_man_ability2.power_level = 3;
    hanged_man_ability2.deity_source = "The Hanged Man";
    
    hanged_man.granted_abilities.push_back(hanged_man_ability1);
    hanged_man.granted_abilities.push_back(hanged_man_ability2);
    
    // The Moon - forbidden knowledge and enigmatic powers
    Deity moon;
    moon.name = "The Moon";
    moon.domain = "Forbidden Knowledge, Madness, and Illusion";
    moon.description = "The enigmatic lunar entity who grants powers from beyond the veil of sanity.";
    moon.theme_color = rl::DARKPURPLE;
    
    Ability moon_ability1;
    moon_ability1.name = "Lunacy Infliction";
    moon_ability1.description = "Induce temporary madness in a target, causing disorientation and hallucinations.";
    moon_ability1.power_level = 3;
    moon_ability1.deity_source = "The Moon";
    
    Ability moon_ability2;
    moon_ability2.name = "Cosmic Whispers";
    moon_ability2.description = "Commune with entities from beyond, gaining cryptic knowledge at risk to sanity.";
    moon_ability2.power_level = 4;
    moon_ability2.deity_source = "The Moon";
    
    moon.granted_abilities.push_back(moon_ability1);
    moon.granted_abilities.push_back(moon_ability2);
    
    // The Tower - destruction and chaotic transformation
    Deity tower;
    tower.name = "The Tower";
    tower.domain = "Destruction, Chaos, and Violent Transformation";
    tower.description = "The embodiment of sudden upheaval who grants powers of chaotic metamorphosis.";
    tower.theme_color = rl::MAROON;
    
    Ability tower_ability1;
    tower_ability1.name = "Chaotic Metamorphosis";
    tower_ability1.description = "Transform part of your body into a monstrous form with unpredictable abilities.";
    tower_ability1.power_level = 4;
    tower_ability1.deity_source = "The Tower";
    
    Ability tower_ability2;
    tower_ability2.name = "Reality Fracture";
    tower_ability2.description = "Create a localized rift in reality, causing chaotic effects in the vicinity.";
    tower_ability2.power_level = 5;
    tower_ability2.deity_source = "The Tower";
    
    tower.granted_abilities.push_back(tower_ability1);
    tower.granted_abilities.push_back(tower_ability2);
    
    // The Star - cosmic connections and elemental manipulation
    Deity star;
    star.name = "The Star";
    star.domain = "Cosmic Forces, Alchemy, and Elemental Transformation";
    star.description = "The celestial guide who grants powers of elemental transmutation and cosmic alignment.";
    star.theme_color = rl::DARKGREEN;
    
    Ability star_ability1;
    star_ability1.name = "Alchemical Transmutation";
    star_ability1.description = "Transform one material into another using principles of cosmic alchemy.";
    star_ability1.power_level = 3;
    star_ability1.deity_source = "The Star";
    
    Ability star_ability2;
    star_ability2.name = "Celestial Alignment";
    star_ability2.description = "Temporarily align yourself with cosmic forces, enhancing all magical abilities.";
    star_ability2.power_level = 4;
    star_ability2.deity_source = "The Star";
    
    star.granted_abilities.push_back(star_ability1);
    star.granted_abilities.push_back(star_ability2);
    
    // The Devil - forbidden pacts and corruption
    Deity devil;
    devil.name = "The Devil";
    devil.domain = "Temptation, Corruption, and Forbidden Pacts";
    devil.description = "The tempter who grants powers through dark bargains and forbidden desires.";
    devil.theme_color = rl::RED;
    
    Ability devil_ability1;
    devil_ability1.name = "Infernal Contract";
    devil_ability1.description = "Create a binding pact with an infernal entity to gain power at a future cost.";
    devil_ability1.power_level = 5;
    devil_ability1.deity_source = "The Devil";
    
    Ability devil_ability2;
    devil_ability2.name = "Corrupting Touch";
    devil_ability2.description = "Infuse a person or object with subtle corruption that spreads over time.";
    devil_ability2.power_level = 3;
    devil_ability2.deity_source = "The Devil";
    
    devil.granted_abilities.push_back(devil_ability1);
    devil.granted_abilities.push_back(devil_ability2);
    
    // Add all deities to the vector
    deities.push_back(hierophant);
    deities.push_back(hermit);
    deities.push_back(hanged_man);
    deities.push_back(moon);
    deities.push_back(tower);
    deities.push_back(star);
    deities.push_back(devil);
    
    return deities;
}

// UI Functions
fn void drawButton(int x, int y, int width, int height, String text, rl::Color color, bool highlighted) 
{
    rl::Rectangle buttonRect = {(float)x, (float)y, (float)width, (float)height};
    
    if (highlighted) 
    {
        rl::drawRectangleRec(buttonRect, rl::ColorAlpha(color, 0.8f));
        rl::drawRectangleLinesEx(buttonRect, 2, rl::WHITE);
    } 
    else 
    {
        rl::drawRectangleRec(buttonRect, rl::ColorAlpha(color, 0.6f));
        rl::drawRectangleLinesEx(buttonRect, 2, rl::ColorAlpha(rl::WHITE, 0.6f));
    }
    
    rl::drawText(
        text.c_str(),
        x + width/2 - rl::measureText(text.c_str(), 20)/2,
        y + height/2 - 10,
        20,
        rl::WHITE
    );
}

fn bool isMouseOverRect(int x, int y, int width, int height) 
{
    rl::Vector2 mousePos = rl::getMousePosition();
    return (mousePos.x >= x && mousePos.x <= x + width && mousePos.y >= y && mousePos.y <= y + height);
}

// Screen drawing functions
fn void drawTitleScreen(GameState* state) 
{
    // Draw the title
    rl::drawText(
        "HEXBOUND",
        SCREEN_WIDTH/2 - rl::measureText("HEXBOUND", 80)/2,
        SCREEN_HEIGHT/4,
        80,
        rl::WHITE
    );
    
    rl::drawText(
        "Deity-Powered Character Creator",
        SCREEN_WIDTH/2 - rl::measureText("Deity-Powered Character Creator", 30)/2,
        SCREEN_HEIGHT/4 + 100,
        30,
        rl::GRAY
    );
    
    // Draw start button
    bool highlight = isMouseOverRect(SCREEN_WIDTH/2 - 150, SCREEN_HEIGHT/2 + 100, 300, 60);
    drawButton(SCREEN_WIDTH/2 - 150, SCREEN_HEIGHT/2 + 100, 300, 60, "Start Character Creation", rl::DARKPURPLE, highlight);
    
    if (highlight && rl::isMouseButtonPressed(rl::MOUSE_BUTTON_LEFT)) 
    {
        state.current_screen = CHARACTER_CREATION;
    }
}

fn void drawCharacterCreationScreen(GameState* state) 
{
    rl::drawText(
        "Create Your Character",
        SCREEN_WIDTH/2 - rl::measureText("Create Your Character", 40)/2,
        50,
        40,
        rl::WHITE
    );
    
    // Character name input field
    rl::drawText("Character Name:", 100, 150, 20, rl::WHITE);
    rl::drawRectangle(100, 180, 400, 40, rl::DARKGRAY);
    rl::drawText(state.player.name.c_str(), 110, 190, 20, rl::WHITE);
    
    // Draw attributes
    rl::drawText("Attributes:", 100, 250, 30, rl::WHITE);
    
    for (int i = 0; i < state.player.attributes.size(); i++) 
    {
        int y_pos = 300 + i * 50;
        rl::drawText(state.player.attributes[i].name.c_str(), 100, y_pos, 20, rl::WHITE);
        
        // Minus button
        bool minus_highlight = isMouseOverRect(350, y_pos, 30, 30);
        drawButton(350, y_pos, 30, 30, "-", rl::RED, minus_highlight);
        
        // Attribute value
        char[10] value_str;
        sprintf(value_str, "%d", state.player.attributes[i].value);
        rl::drawText(value_str, 400, y_pos, 20, rl::WHITE);
        
        // Plus button
        bool plus_highlight = isMouseOverRect(440, y_pos, 30, 30);
        drawButton(440, y_pos, 30, 30, "+", rl::GREEN, plus_highlight);
    }
    
    // Character appearance preview - placeholder
    rl::drawRectangle(SCREEN_WIDTH - 500, 150, 400, 500, rl::DARKGRAY);
    rl::drawText("Character Preview", SCREEN_WIDTH - 500 + 100, 160, 20, rl::WHITE);
    
    // Placeholder character silhouette
    rl::drawCircle(SCREEN_WIDTH - 300, 300, 50, rl::LIGHTGRAY);  // Head
    rl::drawRectangle(SCREEN_WIDTH - 325, 350, 50, 150, rl::LIGHTGRAY);  // Body
    
    // Continue to deity selection button
    bool continue_highlight = isMouseOverRect(SCREEN_WIDTH/2 - 150, SCREEN_HEIGHT - 100, 300, 60);
    drawButton(SCREEN_WIDTH/2 - 150, SCREEN_HEIGHT - 100, 300, 60, "Choose Your Deities", rl::DARKPURPLE, continue_highlight);
    
    if (continue_highlight && rl::isMouseButtonPressed(rl::MOUSE_BUTTON_LEFT)) 
    {
        state.current_screen = DEITY_SELECTION;
    }
}

fn void drawDeitySelectionScreen(GameState* state) 
{
    rl::drawText(
        "Choose Your Deities",
        SCREEN_WIDTH/2 - rl::measureText("Choose Your Deities", 40)/2,
        50,
        40,
        rl::WHITE
    );
    
    rl::drawText(
        "Select up to 3 deities to worship. Their powers will become yours.",
        SCREEN_WIDTH/2 - rl::measureText("Select up to 3 deities to worship. Their powers will become yours.", 20)/2,
        100,
        20,
        rl::LIGHTGRAY
    );
    
    // Draw deity selection cards
    int cardsPerRow = 3;
    int cardWidth = 400;
    int cardHeight = 350;
    int margin = 50;
    int startX = (SCREEN_WIDTH - (cardWidth * cardsPerRow + margin * (cardsPerRow - 1))) / 2;
    int startY = 150;
    
    for (int i = 0; i < state.available_deities.size(); i++) 
    {
        int row = i / cardsPerRow;
        int col = i % cardsPerRow;
        int x = startX + col * (cardWidth + margin);
        int y = startY + row * (cardHeight + margin);
        
        // Check if deity is already selected
        bool isSelected = false;
        foreach (Deity[*] deity : state.player.worshipped_deities) 
        {
            if (deity.name == state.available_deities[i].name) 
            {
                isSelected = true;
                break;
            }
        }
        
        bool isMouseOver = isMouseOverRect(x, y, cardWidth, cardHeight);
        
        // Draw card background
        rl::drawRectangleRounded(
            {(float)x, (float)y, (float)cardWidth, (float)cardHeight},
            0.1f,
            8,
            isSelected ? state.available_deities[i].theme_color : 
                      (isMouseOver ? rl::ColorAlpha(state.available_deities[i].theme_color, 0.7f) : 
                                  rl::ColorAlpha(state.available_deities[i].theme_color, 0.4f))
        );
        
        // Draw deity name
        rl::drawText(
            state.available_deities[i].name.c_str(),
            x + cardWidth/2 - rl::measureText(state.available_deities[i].name.c_str(), 30)/2,
            y + 20,
            30,
            rl::WHITE
        );
        
        // Draw deity domain
        rl::drawText(
            state.available_deities[i].domain.c_str(),
            x + cardWidth/2 - rl::measureText(state.available_deities[i].domain.c_str(), 20)/2,
            y + 60,
            20,
            rl::LIGHTGRAY
        );
        
        // Draw deity description
        rl::drawText(
            state.available_deities[i].description.c_str(),
            x + 20,
            y + 100,
            16,
            rl::WHITE
        );
        
        // Draw abilities
        rl::drawText("Granted Abilities:", x + 20, y + 160, 18, rl::WHITE);
        
        for (int j = 0; j < state.available_deities[i].granted_abilities.size(); j++) 
        {
            rl::drawText(
                state.available_deities[i].granted_abilities[j].name.c_str(),
                x + 30,
                y + 190 + j * 40,
                16,
                rl::WHITE
            );
            rl::drawText(
                state.available_deities[i].granted_abilities[j].description.c_str(),
                x + 40,
                y + 210 + j * 40,
                14,
                rl::LIGHTGRAY
            );
        }
        
        // Handle click on deity card
        if (isMouseOver && rl::isMouseButtonPressed(rl::MOUSE_BUTTON_LEFT)) 
        {
            bool found = false;
            
            // Check if deity is already selected
            for (int j = 0; j < state.player.worshipped_deities.size(); j++) 
            {
                if (state.player.worshipped_deities[j].name == state.available_deities[i].name) 
                {
                    // Deselect deity
                    state.player.worshipped_deities.erase(state.player.worshipped_deities.begin() + j);
                    found = true;
                    break;
                }
            }
            
            // If not selected already and we have less than 3 deities, add it
            if (!found && state.player.worshipped_deities.size() < 3) 
            {
                state.player.worshipped_deities.push_back(state.available_deities[i]);
                
                // Add deity's abilities to character
                foreach (Ability[*] ability : state.available_deities[i].granted_abilities) 
                {
                    state.player.abilities.push_back(ability);
                }
            }
        }
    }
    
    // Continue button
    bool continue_highlight = isMouseOverRect(SCREEN_WIDTH/2 - 150, SCREEN_HEIGHT - 100, 300, 60);
    drawButton(SCREEN_WIDTH/2 - 150, SCREEN_HEIGHT - 100, 300, 60, "Complete Character", rl::DARKPURPLE, continue_highlight);
    
    if (continue_highlight && rl::isMouseButtonPressed(rl::MOUSE_BUTTON_LEFT)) 
    {
        if (state.player.worshipped_deities.size() > 0) 
        {
            state.current_screen = CHARACTER_SHEET;
        }
    }
}

fn void drawCharacterSheet(GameState* state) 
{
    rl::drawText(
        "Character Sheet",
        SCREEN_WIDTH/2 - rl::measureText("Character Sheet", 40)/2,
        50,
        40,
        rl::WHITE
    );
    
    // Character name and basic info
    rl::drawText(state.player.name.c_str(), 100, 120, 30, rl::WHITE);
    
    // Draw attributes
    rl::drawText("Attributes:", 100, 170, 25, rl::WHITE);
    
    for (int i = 0; i < state.player.attributes.size(); i++) 
    {
        int y_pos = 210 + i * 40;
        rl::drawText(state.player.attributes[i].name.c_str(), 100, y_pos, 20, rl::WHITE);
        
        char[10] value_str;
        sprintf(value_str, "%d", state.player.attributes[i].value);
        rl::drawText(value_str, 250, y_pos, 20, rl::WHITE);
        
        sprintf(value_str, "(+%d)", state.player.attributes[i].modifier);
        rl::drawText(value_str, 300, y_pos, 20, rl::LIGHTGRAY);
    }
    
    // Draw worshipped deities
    rl::drawText("Worshipped Deities:", 100, 470, 25, rl::WHITE);
    
    for (int i = 0; i < state.player.worshipped_deities.size(); i++) 
    {
        int y_pos = 510 + i * 40;
        rl::drawText(state.player.worshipped_deities[i].name.c_str(), 100, y_pos, 20, state.player.worshipped_deities[i].theme_color);
        rl::drawText(state.player.worshipped_deities[i].domain.c_str(), 250, y_pos, 16, rl::LIGHTGRAY);
    }
    
    // Draw abilities
    rl::drawText("Abilities:", SCREEN_WIDTH/2 + 100, 170, 25, rl::WHITE);
    
    for (int i = 0; i < state.player.abilities.size(); i++) 
    {
        int y_pos = 210 + i * 60;
        rl::drawText(state.player.abilities[i].name.c_str(), SCREEN_WIDTH/2 + 100, y_pos, 20, rl::WHITE);
        rl::drawText(state.player.abilities[i].description.c_str(), SCREEN_WIDTH/2 + 100, y_pos + 25, 16, rl::LIGHTGRAY);
        
        // Draw power level as stars
        for (int j = 0; j < state.player.abilities[i].power_level; j++) 
        {
            rl::drawText("*", SCREEN_WIDTH/2 + 400 + j * 15, y_pos, 20, rl::GOLD);
        }
        
        // Draw source deity
        rl::drawText("(", SCREEN_WIDTH - 220, y_pos, 16, rl::LIGHTGRAY);
        rl::drawText(state.player.abilities[i].deity_source.c_str(), SCREEN_WIDTH - 210, y_pos, 16, rl::LIGHTGRAY);
        rl::drawText(")", SCREEN_WIDTH - 210 + rl::measureText(state.player.abilities[i].deity_source.c_str(), 16), y_pos, 16, rl::LIGHTGRAY);
    }
    
    // Return to deity selection button
    bool back_highlight = isMouseOverRect(100, SCREEN_HEIGHT - 100, 300, 60);
    drawButton(100, SCREEN_HEIGHT - 100, 300, 60, "Edit Deity Choices", rl::DARKPURPLE, back_highlight);
    
    if (back_highlight && rl::isMouseButtonPressed(rl::MOUSE_BUTTON_LEFT)) 
    {
        state.current_screen = DEITY_SELECTION;
    }
    
    // Start game button - placeholder for future expansion
    bool start_highlight = isMouseOverRect(SCREEN_WIDTH - 400, SCREEN_HEIGHT - 100, 300, 60);
    drawButton(SCREEN_WIDTH - 400, SCREEN_HEIGHT - 100, 300, 60, "Save Character", rl::DARKGREEN, start_highlight);
}

// Input handling
fn void handleInput(GameState* state) 
{
    if (state.current_screen == CHARACTER_CREATION) 
    {
        // Very basic name input - for demonstration purposes
        int key = rl::getKeyPressed();
        if (key >= 32 && key <= 125 && state.player.name.length() < 20) 
        {
            state.player.name += (char)key;
        }
        if (rl::isKeyPressed(rl::KEY_BACKSPACE) && state.player.name.length() > 0) 
        {
            state.player.name.pop_back();
        }
        
        // Handle attribute adjustments
        for (int i = 0; i < state.player.attributes.size(); i++) 
        {
            int y_pos = 300 + i * 50;
            
            // Check minus button
            if (isMouseOverRect(350, y_pos, 30, 30) && rl::isMouseButtonPressed(rl::MOUSE_BUTTON_LEFT)) 
            {
                if (state.player.attributes[i].value > 3) 
                {
                    state.player.attributes[i].value--;
                    // Update modifier: (attribute - 10) / 2, rounded down
                    state.player.attributes[i].modifier = (state.player.attributes[i].value - 10) / 2;
                }
            }
            
            // Check plus button
            if (isMouseOverRect(440, y_pos, 30, 30) && rl::isMouseButtonPressed(rl::MOUSE_BUTTON_LEFT)) 
            {
                if (state.player.attributes[i].value < 18) 
                {
                    state.player.attributes[i].value++;
                    // Update modifier
                    state.player.attributes[i].modifier = (state.player.attributes[i].value - 10) / 2;
                }
            }
        }
    }
}

fn void drawCurrentScreen(GameState* state) 
{
    switch (state.current_screen) 
    {
        case TITLE:
            drawTitleScreen(state);
            break;
        case CHARACTER_CREATION:
            drawCharacterCreationScreen(state);
            break;
        case DEITY_SELECTION:
            drawDeitySelectionScreen(state);
            break;
        case CHARACTER_SHEET:
            drawCharacterSheet(state);
            break;
        default:
            break;
    }
}                           

fn void main() {
    rl::initWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "Hexbound");
    rl::setTargetFPS(FPS);
    
    // Initialize game state
    GameState game_state;
    game_state.current_screen = TITLE;
    game_state.player = createNewCharacter();
    game_state.available_deities = initDeities();
    game_state.selected_deity_index = -1;
    
    while(!rl::windowShouldClose()) { 
        // Handle input
        handleInput(game_state);
        
        // Draw
        rl::beginDrawing();
        rl::clearBackground(rl::BLACK);
        
        drawCurrentScreen(game_state);
        
        rl::endDrawing();
    }
    
    rl::closeWindow();
}
