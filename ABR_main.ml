(* Point d'entrée pour l'algo de l'arbre ABR *)
(* Chaque lancement de l'algo écrit le nouvel arbre dans un .dot *)
let () =
    if Array.length Sys.argv < 2 then
        Printf.printf "Usage: %s <taille_arbre>\n" Sys.argv.(0)
    else
        let n = int_of_string Sys.argv.(1) in 
        let a_resultat = ABR.algoABR n in
        (* Arbre.afficher a_resultat; *) (* DEBUG *)
        EcritureDot.ecritureArbreDot a_resultat "arbreABR.dot"