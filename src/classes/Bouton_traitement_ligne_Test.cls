//(c) octobre 2017 by Eric Adam (UBICLOUDER)
@istest
public class Bouton_traitement_ligne_Test {

    Private Static testmethod void Testbouton(){ 
        
        Bouton_traitement_ligne objController = new Bouton_traitement_ligne();
        objController.ImportLigne();
        objController.TraitementLigne();
        objController.TraitementGroupe();
         
    }
}