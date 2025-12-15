(* ABR.ml : Algorithme de l'arbre de type ABR *)
Random.self_init ();;


(** Ajoute 2 noeuds dans l'arborescence : 1 interne et 1 feuille, après avoir accédé à une feuille particulière de l'arbre.
    On modifie également les tableaux des noeuds et des feuilles de l'arbre pour réfléter ces ajouts. 
    Suppose que les tailles des tableaux aient été allouées au préalable pour permettre les ajouts.
    @param noeudFeuilleCible La feuille cible où ajouter un nouveau noeud interne, avec une nouvelle feuille.
    @param a L'arbre dans lequel on ajoute le nouveau noeud.
    @return Le nouveau noeud interne.
*)
let ajouteNoeudABR (noeudFeuilleCible : Arbre.noeud) (a : Arbre.arbre) : Arbre.noeud =
    let l = a.t_noeuds in

    (* l+1 : id du nouveau noeud interne, l+2 : id du nouveau noeud feuille *)

    (* Création de la nouvelle feuille *)
    let nouvelleFeuille = Arbre.Empty { id = l+2; p = None } in

    (* Création du nouveau noeud interne *)
    let nouveauInterne =
        (* noeudFeuilleCible devient enfant gauche du nouvel interne *)
        Arbre.Noeud { 
            id = l+1;
            g = noeudFeuilleCible; 
            d = nouvelleFeuille; 
            p = match noeudFeuilleCible with 
                |Empty e -> e.p
                |Noeud n -> n.p;
        }
    in
        (* Le parent de noeudFeuilleCible voit son enfant noeudFeuilleCible remplacé par le nouveau noeud interne (si le parent existe) *)
        (match noeudFeuilleCible with
            | Empty e -> (match e.p with
                            | Some parent -> Arbre.remplacerEnfant parent noeudFeuilleCible nouveauInterne
                            | None -> () (* pas de parent : cible est racine *)
                        )  
            | Noeud n -> (match n.p with
                            | Some parent -> Arbre.remplacerEnfant parent noeudFeuilleCible nouveauInterne
                            | None -> () (* pas de parent : cible est racine *)
                        )
        );
    
        (* Le nouveau noeud interne devient parent du noeudFeuilleCible et de la nouvelleFeuille *)
        Arbre.mettre_parent noeudFeuilleCible nouveauInterne;
        Arbre.mettre_parent nouvelleFeuille nouveauInterne;

        (* Mise à jour des tableaux et de leurs nb de cases utilisées *)
        (* On ajoute notamment les 2 nouveaux noeuds dans les tableaux *)
        a.noeuds.(l) <- nouveauInterne;
        a.noeuds.(l+1) <- nouvelleFeuille;
        a.feuilles.(a.t_feuilles) <- nouvelleFeuille;
        a.t_noeuds <- a.t_noeuds+2;
        a.t_feuilles <- a.t_feuilles+1;

        (* On renvoit le nouveau noeud interne *)
        nouveauInterne


(** Crée récursivement un nouvel arbre, en modifiant à chaque récursion un arbre créé lors du cas de base.
    Cette modification revient à insérer dans la structure 2 nouveaux noeuds (1 interne et 1 feuille) à chaque itération récursive.
    @param n Le nombre de noeuds internes à ajouter successivement dans un arbre, pour arriver à l'arbre voulu.
    @param nInitial Le paramètre [n] initial (le nombre total de noeuds internes dans l'arbre final).
    @return L'arbre ayant [n] noeuds internes, après ajouts successifs.
*)
let rec creeArbreABR (n : int) (nInitial : int) : Arbre.arbre =
    (* Cas de base, un arbre avec une unique feuille *)
    if n <= 0 
        (* Dans un arbre de taille n, on a 2*n+1 noeuds au total, et n+1 feuilles *)
        then Arbre.arbre_vide ((2*nInitial)+1) (nInitial+1)  (* ici nInitial->n de notre arbre final *)
    else
        
        let a = creeArbreABR (n-1) nInitial in (* On récupère récursivement l'arbre nécessaire *)
        let i = Random.int a.t_feuilles in
        let cibleFeuille = a.feuilles.(i) in (* On choisit de manière uniforme l'une des feuilles de l'arbre *)
        let nouveauInterne = ajouteNoeudABR cibleFeuille a in (* On ajoute les nouveaux noeuds en place dans l'arbre *)
        (* Mise à jour de la racine si nécessaire *)
        if Arbre.egaliteNoeuds a.racine cibleFeuille then
        a.racine <- nouveauInterne;
        a (* On renvoit l'arbre mis à jour *)


(** Applique l'algorithme de l'arbre ABR, en appelant creeArbreABR avec n pour les 2 paramètres.
    @param n La taille de l'arbre (en nombre de noeuds internes) à créer.
    @return L'arbre ayant n noeuds internes, après ajouts successifs.
*)
let algoABR (n : int) : Arbre.arbre = creeArbreABR n n


(* Point d'entrée pour l'algo de l'arbre ABR *)
(* Chaque lancement de l'algo écrit le nouvel arbre dans un .dot *)
let () =
    if Array.length Sys.argv < 2 then
        Printf.printf "Usage: %s <taille_arbre>\n" Sys.argv.(0)
    else
        let n = int_of_string Sys.argv.(1) in 
        let a_resultat = algoABR n in
        (* Arbre.afficher a_resultat; *) (* DEBUG *)
        EcritureDot.ecritureArbreDot a_resultat "arbreABR.dot"