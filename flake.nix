{ ... }@args: 
{
	description = "The Asa's nix configuration";
	inputs = (import ./flake/inputs.nix args).inputs;
	outputs = { ... }@inputs: (import ./flake/outputs.nix inputs).output;
}