-- AchievementProbe v6
-- COMPLETE ACHIEVEMENT CATALOG
-- CET / LUA ONLY
-- READ ONLY
--
-- Generates CP2077_Achievement_Logic.txt
--
-- Dumps every achievement record and every useful field
-- CET can currently expose for later use by Cynosure.

local OUTPUT_FILE = "CP2077_Achievement_Logic.txt"

------------------------------------------------------------
-- Helpers
------------------------------------------------------------

local function safeCall(fn)
    local ok, result = pcall(fn)

    if ok then
        return result
    end

    return nil
end

local function writeLine(file, value)
    file:write(tostring(value or "") .. "\n")
end

local function localized(value)

    if value == nil then
        return "<nil>"
    end

    local result = safeCall(function()
        return Game.GetLocalizedText(value)
    end)

    if result ~= nil then
        return tostring(result)
    end

    return "<unavailable>"
end

local function getID(record)

    return safeCall(function()
        return TDBID.ToStringDEBUG(record:GetID())
    end) or "<unknown>"
end

------------------------------------------------------------
-- Main
------------------------------------------------------------

local function runProbe()

    local file = io.open(OUTPUT_FILE, "w")

    if not file then
        return
    end

    writeLine(file, "============================================================")
    writeLine(file, "CYBERPUNK 2077 ACHIEVEMENT DATABASE")
    writeLine(file, "AchievementProbe v6")
    writeLine(file, "============================================================")
    writeLine(file, "")

    --------------------------------------------------------
    -- Platform information
    --------------------------------------------------------

    writeLine(file, "PLATFORM")
    writeLine(file, "------------------------------------------------------------")

    local system = safeCall(function()
        return Game.GetAchievementSystem()
    end)

    if system then

        writeLine(file, "AchievementSystem: FOUND")

        local className = safeCall(function()
            return system:GetClassName()
        end)

        local serviceName = safeCall(function()
            return system:GetServiceName()
        end)

        writeLine(
            file,
            "Class: " .. tostring(className or "<unknown>")
        )

        writeLine(
            file,
            "Service: " .. tostring(serviceName or "<unknown>")
        )

    else

        writeLine(file, "AchievementSystem: NOT FOUND")

    end

    --------------------------------------------------------
    -- Obtain achievement records
    --------------------------------------------------------

    local records = safeCall(function()
        return TweakDB:GetRecords(
            "gamedataAchievement_Record"
        )
    end)

    if not records then

        writeLine(file, "")
        writeLine(file, "ERROR: Achievement records unavailable")

        file:close()
        return
    end

    writeLine(file, "")
    writeLine(file, "TOTAL RECORDS: " .. tostring(#records))
    writeLine(file, "")

    --------------------------------------------------------
    -- Achievement records
    --------------------------------------------------------

    for index, record in ipairs(records) do

        local id = getID(record)

        local className = safeCall(function()
            return record:GetClassName()
        end)

        ----------------------------------------------------
        -- DisplayName
        ----------------------------------------------------

        local displayNameObject = safeCall(function()
            return record:DisplayName()
        end)

        local displayNameKey = "<unavailable>"
        local displayName = "<unavailable>"

        if displayNameObject ~= nil then

            local rawValue = safeCall(function()
                return displayNameObject.value
            end)

            if rawValue ~= nil then
                displayNameKey = tostring(rawValue)
                displayName = localized(rawValue)
            end
        end

        ----------------------------------------------------
        -- Description
        ----------------------------------------------------

        local descriptionObject = safeCall(function()
            return record:LocalizedDescription()
        end)

        local descriptionRaw = "<unavailable>"
        local description = "<unavailable>"

        if descriptionObject ~= nil then
            descriptionRaw = tostring(descriptionObject)
            description = localized(descriptionObject)
        end

        ----------------------------------------------------
        -- Record
        ----------------------------------------------------

        writeLine(file, "============================================================")
        writeLine(
            file,
            string.format(
                "ACHIEVEMENT %03d",
                index
            )
        )
        writeLine(file, "============================================================")

        writeLine(file, "InternalID:")
        writeLine(file, "  " .. tostring(id))

        writeLine(file, "")

        writeLine(file, "DisplayName:")
        writeLine(file, "  " .. tostring(displayName))

        writeLine(file, "")

        writeLine(file, "Description:")
        writeLine(file, "  " .. tostring(description))

        writeLine(file, "")

        writeLine(file, "DisplayNameRaw:")
        writeLine(file, "  " .. tostring(displayNameKey))

        writeLine(file, "")

        writeLine(file, "DescriptionRaw:")
        writeLine(file, "  " .. tostring(descriptionRaw))

        writeLine(file, "")

        writeLine(file, "RecordClass:")
        writeLine(file, "  " .. tostring(className or "<unknown>"))

        ----------------------------------------------------
        -- Known useful classification
        ----------------------------------------------------

        local lowerID = string.lower(tostring(id))
        local lowerName = string.lower(tostring(displayName))

        local category = "Other"

        if
            lowerID:find("thedevil", 1, true) or
            lowerID:find("thestar", 1, true) or
            lowerID:find("thesun", 1, true) or
            lowerID:find("temperance", 1, true) or
            lowerID:find("thetower", 1, true) or
            lowerID:find("kingof", 1, true)
        then
            category = "Ending / Story Outcome"

        elseif
            lowerName:find("pacifica", 1, true) or
            lowerName:find("wasteland", 1, true) or
            lowerName:find("little tokyo", 1, true) or
            lowerName:find("mean streets", 1, true) or
            lowerName:find("city lights", 1, true) or
            lowerName:find("jungle", 1, true) or
            lowerName:find("elementary", 1, true)
        then
            category = "District Completion"

        elseif
            lowerName:find("frequent flyer", 1, true)
        then
            category = "Fast Travel"

        elseif
            lowerName:find("autojock", 1, true)
        then
            category = "Vehicles"

        elseif
            lowerName:find("wandering fool", 1, true)
        then
            category = "Tarot"

        elseif
            lowerName:find("law", 1, true)
        then
            category = "Cyberpsycho"

        elseif
            lowerName:find("road", 1, true) or
            lowerName:find("judy", 1, true) or
            lowerName:find("protect and serve", 1, true) or
            lowerName:find("bad decisions", 1, true)
        then
            category = "Character Storyline"
        end

        writeLine(file, "")
        writeLine(file, "SuggestedCategory:")
        writeLine(file, "  " .. category)

        writeLine(file, "")
    end

    --------------------------------------------------------
    -- Compact lookup table
    --------------------------------------------------------

    writeLine(file, "")
    writeLine(file, "############################################################")
    writeLine(file, "COMPACT LOOKUP TABLE")
    writeLine(file, "############################################################")
    writeLine(file, "")

    for index, record in ipairs(records) do

        local id = getID(record)

        local name = "<unknown>"

        local display = safeCall(function()
            return record:DisplayName()
        end)

        if display ~= nil then

            local raw = safeCall(function()
                return display.value
            end)

            if raw ~= nil then
                name = localized(raw)
            end
        end

        writeLine(
            file,
            string.format(
                "%03d | %s | %s",
                index,
                tostring(id),
                tostring(name)
            )
        )
    end

    --------------------------------------------------------
    -- Cynosure-important records
    --------------------------------------------------------

    writeLine(file, "")
    writeLine(file, "############################################################")
    writeLine(file, "CYNOSURE TARGETS")
    writeLine(file, "############################################################")
    writeLine(file, "")

    local targets = {
        "Achievements.TheDevil",
        "Achievements.TheStar",
        "Achievements.TheSun",
        "Achievements.Temperance",
        "Achievements.TheTower",

        "Achievements.Fortuneteller",

        "Achievements.GetMeThereScottie",
        "Achievements.Gearhead",

        "Achievements.IAmMaxTac",

        "Achievements.YipMan",
        "Achievements.LikeFatherLIkeSon",
        "Achievements.LittleTokyo",
        "Achievements.TradeUnion",
        "Achievements.ThisIsPacifica",
        "Achievements.NoMansLand",
        "Achievements.Bladerunner"
    }

    for _, targetID in ipairs(targets) do

        local found = false

        for _, record in ipairs(records) do

            if getID(record) == targetID then

                found = true

                local name = "<unknown>"
                local description = "<unknown>"

                local display = safeCall(function()
                    return record:DisplayName()
                end)

                if display ~= nil then

                    local raw = safeCall(function()
                        return display.value
                    end)

                    if raw ~= nil then
                        name = localized(raw)
                    end
                end

                local desc = safeCall(function()
                    return record:LocalizedDescription()
                end)

                if desc ~= nil then
                    description = localized(desc)
                end

                writeLine(file, targetID)
                writeLine(file, "  Name: " .. tostring(name))
                writeLine(
                    file,
                    "  Description: " .. tostring(description)
                )
                writeLine(file, "")

                break
            end
        end

        if not found then
            writeLine(file, targetID)
            writeLine(file, "  NOT FOUND")
            writeLine(file, "")
        end
    end

    --------------------------------------------------------
    -- End
    --------------------------------------------------------

    writeLine(file, "############################################################")
    writeLine(file, "END OF ACHIEVEMENT DATABASE")
    writeLine(file, "############################################################")
    writeLine(file, "")
    writeLine(file, "READ ONLY")
    writeLine(file, "NO ACHIEVEMENTS MODIFIED")

    file:flush()
    file:close()
end

registerForEvent("onInit", function()
    runProbe()
end)