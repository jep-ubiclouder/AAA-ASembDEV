//(c) Décembre 2016 by Eric Adam (UBICLOUDER)
// MAJ Octobre 2017 by Eric Adam (UBICLOUDER)

global class Bouton_traitement_ligne
{

    public void TraitementLigne() // you can pass parameters
    { 
        
        BatchtraitementLigne BatchTL = new BatchtraitementLigne();
        Database.executebatch(BatchTL,10);
    }

    public void ImportLigne() // you can pass parameters
    { 

        BatchImportLigne BatchIL = new BatchImportLigne();
        Database.executebatch(BatchIL,10);

    }

    public void TraitementGroupe() // you can pass parameters
    {
        Batchtraitementgroupe BatchTR = new Batchtraitementgroupe();
        Database.executebatch(BatchTR,10);
    }


}