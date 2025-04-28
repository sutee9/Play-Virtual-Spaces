BEFORE YOU START:
- you need Unity 6+
- you need HD SRP pipline 17 or higher
- there is wind prefab which will manage wind at your scene
Be patient HD RP tech is so fluid... we coudn't follow every beta version

Step 1 - Import our HD RP 17 Unity 6 Fire and Smoke compatibility pack
Step 2 - Render setup.
!!!! IMPORTANT !!!! Open "Project settings" ->"Gaphics"-> "Pipline Specific Settings" ->  "Diffusion Profile List"
	and drag and drop our SSS settings diffusion profiles for particles, glass, obsidian into Diffusion profile list:
		  NM_SSSSettings_Smoke
	Without this smoke materials will not become affected by scattering and they will look wrong.

