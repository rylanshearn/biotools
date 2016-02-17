#!/usr/bin/perl -w
use strict;

# reecrit les fichiers fasta avec une ligne unique par sequence (+le nom) :
# >nom_sequence
# sequence

# input : fichier fasta
# output : fichier fasta avec moins de lignes


# commande :   ./reecriture_fasta_ligne_unique_par_sequence.pl sequences.fst

# ouverture du fichier .fst
my $nom_fichier_entree = $ARGV[0] or die "Erreur ! Syntaxe correcte : ./enleveur_annotations_fasta.pl sequences.fst !\n"; 
open(FICHIER_ENTREE, "<$nom_fichier_entree") or die("Erreur ouverture $nom_fichier_entree ");

# récupération des données :
my @sequences = <FICHIER_ENTREE> ;
chomp(@sequences) ;

# ouverture du fichier de sortie :
my $outFile = "$nom_fichier_entree.propre";
open(OUT, ">$outFile") ;


# boucle parcourant chaque ligne du fichier de séquences et enlevant les annotations si nécessaire :
my $nbr_lignes = scalar(@sequences);

for (my $i=0 ; $i<$nbr_lignes; $i+=1) {

	my $premier_caractere = substr($sequences[$i], 0, 1) ;
	if ($premier_caractere eq ">") {
		# la ligne $i correspond au nom d'une sequence de l'alignement.
		my $nom_seq = $sequences[$i] ;
		print(OUT "$nom_seq\n") ;

		# recuperation de la sequence :
		my $seq = "" ;
		my $k = $i + 1 ;
		while ($k < $nbr_lignes) {
			my $debut = substr($sequences[$k], 0, 1) ;
			last if $debut eq ">" ;
			my $data = $sequences[$k] ;
			$seq = $seq.$data ;
			$k++ ;
		}

		# ecriture de la sequence dans le fichier de sortie :
		print(OUT "$seq\n") ;
	}
}


close(OUT) ;
