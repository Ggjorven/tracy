MacOSVersion = MacOSVersion or "14.5"

project "Tracy"
	kind "StaticLib"
	language "C++"
	cppdialect "C++17"
	staticruntime "Off"
	warnings "Off"

	targetdir ("%{wks.location}/bin/" .. outputdir .. "/%{prj.name}")
	objdir ("%{wks.location}/bin-int/" .. outputdir .. "/%{prj.name}")

	files
	{
		"public/client/**.h",
		"public/client/**.hpp",
		"public/client/**.cpp",

		"public/common/**.h",
		"public/common/**.hpp",
		"public/common/**.cpp",

		"public/tracy/**.h",
		"public/tracy/**.hpp",
		"public/tracy/**.cpp",

		"public/libbacktrace/alloc.cpp",
		"public/libbacktrace/sort.cpp",
		"public/libbacktrace/state.cpp"
	}

	includedirs
    {
        "public/"
    }

	defines
	{
		"_CRT_SECURE_NO_WARNINGS"
	}

	filter "system:windows"
		systemversion "latest"
		staticruntime "On"

		links
		{
			"Ws2_32.lib",
			"DbgHelp.lib"
		}

	filter "system:linux"
		systemversion "latest"
		staticruntime "On"

		files
		{
			"public/libbacktrace/posix.cpp",
			"public/libbacktrace/mmapio.cpp",
			"public/libbacktrace/macho.cpp",
			"public/libbacktrace/fileline.cpp",
			"public/libbacktrace/elf.cpp",
			"public/libbacktrace/dwarf.cpp",
		}

	filter "system:macosx"
		systemversion "%{MacOSVersion}"
		staticruntime "On"

		files
		{
			"public/libbacktrace/posix.cpp",
			"public/libbacktrace/mmapio.cpp",
			"public/libbacktrace/macho.cpp",
			"public/libbacktrace/fileline.cpp",
			"public/libbacktrace/dwarf.cpp",
		}

		-- Note: If we don't add the header files to the externalincludedirs
		-- we can't use <angled> brackets to include files.
		externalincludedirs
		{
			"public/"
		}


	filter "configurations:Debug"
		runtime "Debug"
		symbols "On"
		conformancemode "On"

		defines
		{
			"TRACY_ENABLE",
			"TRACY_ON_DEMAND"
		}

	filter "configurations:Release"
		runtime "Release"
		optimize "On"
		conformancemode "On"

		defines
		{
			"TRACY_ENABLE",
			"TRACY_ON_DEMAND"
		}

	filter "configurations:Dist"
		runtime "Release"
		optimize "Full"
		conformancemode "On"
