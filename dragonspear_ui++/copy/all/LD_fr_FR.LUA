JFStrings = {
	JF_All = "Toutes",
	JF_Active = "Actives",
	JF_Completed = "Accomplies",
	JF_Notes = "Mes notes:",
	JF_Edited = "Modifiée:"
}

UIStrings = {
	UI_JMode = "Mode de journal",
	UI_Large = "Grand",
	UI_Small = "Petit",
	UI_JToggle = "Activer cette option vous permet de définir votre journal par défaut avec les versions grandes et petites.",
	UI_QLMode = "Mode de butin rapide",
	UI_QToggle = "Activer cette option vous permet de basculer entre les modes experts et avancés du butin rapide, .",
	UI_Advanced = "Avancé",
	UI_Expert = "Expert",
	UI_QShow = "- Butin rapide au démarrage du jeu :",
	UI_QShowExp = "Cette option vous permet de définir le butin rapide comme étant visible lorsque vous lancez le jeu. Vous pouvez l'activer et la désactiver autant de fois que vous le souhaitez. Note : Le menu de butin rapide restera caché s'il n'y a rien à afficher.",
	UI_Hidden = "Caché",
	UI_Visible = "Visible",
	UI_QRows = "- Rangées :",
	UI_QRowsExp = "Cette option vous permet de sélectionner le nombre de rangées affichées par le mode expert du butin rapide. Seuls les 60 premiers objets seront affichés et vous aurez des pages à défiler pour passer aux 60 objets suivants ou précédents."
}

PPStrings = {
	PP_CHAR_MALE = "Mâle",  -- 'Male'
	PP_CHAR_FEMALE = "Femelle", -- 'Female'
	PP_SORTAZ = "A à Z", -- 'A to Z'
	PP_SORTZA = "Z à A", -- 'Z to A'
	PP_SORTDC = "Par défaut vers personnalisé", -- 'Default to Custom'
	PP_SORTCD = "Personnalisé vers par défaut", -- 'Custom to Default'
	PP_TOTAL = "TOUS LES PORTRAITS", -- 'TOTAL PORTRAITS'
	PP_DEFAULT = "Par défaut : ", -- 'Default: '
	PP_CUSTOM = "Personnalisé : ", -- 'Custom: '
	PP_SORT = "Trier : ", -- 'Sort: '
	PP_SORT_LABEL = "TRIER", -- 'SORT'
	PP_FILENAME = "Nom de dossier : " -- 'Filename'
}

-- beware of the "\n" symbols (they are beginnings of new rows), do not move them, just ignore them
PDD = {
	"TAC0 : -3 \nDégâts : +5 \nFacteur de vitesse: -3 \nAttaque supplémentaire par round : 1/2 (combattants uniquement)",
	"TAC0 : -3 \nDégâts : +4 \nFacteur de vitesse: -1 \nAttaque supplémentaire par round : 1/2 (combattants uniquement)",
	"TAC0 : -3 \nDégâts : +3 \nAttaque supplémentaire par round : 1/2 (combattants uniquement)",
	"TAC0 : -1 \nDégâts : +2 \nAttaque supplémentaire par round : 1/2 (combattants uniquement)",
	"Pas de pénalités",
	"Dégâts : +1 \nVitesse de l'arme : -4 \nChance de coup critique : +1",
	"Dégâts : +1 \nVitesse de l'arme : -2 \nChance de coup critique : +1",
	"CA contre les projectiles : -4",
	"CA contre les projectiles : -2",
	"CA : -2 \nChance de coup critique : +1",
	"CA : -1 \nChance de coup critique : +1" ,
	"THAC0 de l'arme secondaire : +2",
	"THAC0 de l'arme secondaire : +4",
	"THAC0 de l'arme principale : +2\nTHAC0 de l'arme secondaire : +6"
}

duiStrings = {
	ACM_STORED_LABEL = "Mémorisé",
	ACM_ROLL_SPEED_LABEL = "Choisir la fréquence",
	ACM_CHEAT_METHOD = "Choisir mode de triche :",
	ACM_UF_DESCRIPTION = "Le choix de la fréquence est disponible pour la plupart des méthodes.\n\nUtilisez le curseur pour choisir la vitesse qui fonctionne le mieux pour vous et votre configuration.\n",
	ACM_AUTOROLL_BUTTON = "Tirage automatique",
	ACM_RANGEROLL_BUTTON = "Tirage à intervalles",
	ACM_POINTBUY_BUTTON = "Sélection de points",
	ACM_MINSTR_BUTTON = "Minimum du % de force",
	ACM_PRISTR_BUTTON = "Force prioritaire",
	ACM_MAXMAX_BUTTON = "Maximum",
	ACM_AUTOROLL_DESCRIPTION = "Utilise un tirage automatique pour obtenir le plus de points possible.\nMémorise les plus hauts pourcentages de force quand les points sont équivalents et applicables à la race ou à la classe.\n\nPlus vous attendez, plus vous avez de chance d'avoir un haut score.",
	ACM_RANGEROLL_DESCRIPTION = "Utilise un tirage automatique pour obtenir un total compris entre les intervalles que vous avez défini.\nMémorise les plus hauts pourcentages de force quand les points sont équivalents et applicables à la race ou à la classe.\n\nLes valeurs plus élevées peuvent prendre plus de temps.",
	ACM_POINTBUY_DESCRIPTION = "Sélectionnez le total voulu, puis attribuez les points comme vous le souhaitez. (Les choix par défaut sont : 75, 80, 85 et 90).\nMémorise les plus hauts pourcentages de force quand les points sont équivalents et applicables à la race ou à la classe.\n\nRapide !",
	ACM_MINSTR_DESCRIPTION = "Sélectionnez le minimum du pourcentage de force souhaité et le tirage automatique mémorisera le plus haut tirage avec un pourcentage de force supérieur à la valeur que vous avez définie.\n\n\nLes valeurs plus élevées peuvent prendre plus de temps.",
	ACM_PRISTR_DESCRIPTION = "Définir une priorité entre les points et le pourcentage de force. Le tirage automatique sélectionnera une valeur qui correspond à vos critères, Ex :\nDéfinir un intervalle de '91 à 100' avec '-1 point' permettra à un tirage de 93 avec une force de 18/97 d'être mémorisé à la place d'un 94 avec une force de 18/20.\n\nDes nombres trop grands peuvent produire des résultats erronés.",
	ACM_MAXMAX_DESCRIPTION = "Gagnez du temps et mettez toutes vos capacités à 18.\n\n\n\n\n",
	ACM_CHANGEMETHOD_BUTTON = "Changer de méthode",
	ACM_SELMETHOD_AUTOROLL_TEXT = "MÉTHODE : Tirage automatique",
	ACM_SELMETHOD_RANGEROLL_TEXT = "MÉTHODE : Tirage à intervalles",
	ACM_SELMETHOD_RANGEROLL_TO_TEXT = "jusqu'à",
	ACM_SELMETHOD_POINTBUY_TEXT = "MÉTHODE : Achat de points",
	ACM_SELMETHOD_POINTBUY_ACQUIRED = "VALEUR OBTENUE ! Désactivez le tirage automatique !",
	ACM_SELMETHOD_MINSTR_TEXT = "MÉTHODE: Minimum du % de force",
	ACM_SELMETHOD_MINSTR_MINSTR = "Minimum du %",
	ACM_SELMETHOD_PRISTR_TEXT = "MÉTHODE : Force prioritaire en %",
	ACM_SELMETHOD_MAXMAX_TEXT = "MÉTHODE : Maximum",
	ACM_SELMETHOD_MAXMAX_MAXMAX = "Mode de débogage activé.\n\n Appuyez sur Ctrl + 8.",
	ACM_START = "DÉMARRER",
	ACM_STOP = "ARRÊTER",
	ACM_VIEW = "Changer l'organisation",
	ACM_FLATTEN = "Uniformiser les stats",
	ACM_MINIMUM = "Mettre au minimum",
	RG_CLASS_BUTTON = "DESCRIPTION DE LA CLASSE",
	RG_PROFS_BUTTON = "COMPÉTENCES/COMPÉTENCES",
	RG_OVERVIEW = "VUE D'ENSEMBLE",
	RG_RECORD = "Enregistrer",
	RG_UI_TITLE = "Paramètres de l'interface",
	RG_UI_PANEL = "Panneau de menu principal du côté gauche",
	RG_UI_PANEL1 = "Activer cette option affichera le panneau du menu principal du côté gauche, à la place du côté droit. Cela peut-être utile pour certains arrière-plans personnalisés.",
	RG_UI_JOURNAL = "Petit/Grand Journal - DÉSACTIVÉ",
	RG_UI_JOURNAL1 = "Activer cette option permet de passer de l'écran de journal original au nouveau grand journal. - DÉSACTIVÉ",
	RG_UI_CHEAT = "Mode de triche",
	RG_UI_CHEAT1 = "Activer cette option activera le mode de triche. L'option du tirage automatique dans le menu de création de personnage sera disponible. Maintenir le bouton 'Révéler les détails' rendra la zone entièrement explorée.",
	RG_UI_QUICKLOOT = "Barre du butin rapide activée/désactivée par défaut",
	RG_UI_QUICKLOOT1 = "Activer cette option permettra au menu de butin rapide d'être toujours activé au démarrage ou au chargement d'une partie.",
	RG_RANDOM = "Personnage aléatoire",
	RG_PP_TOOLTIP = "Choisissez votre portrait depuis la liste. Pour obtenir plus d'informations à propos des portraits personnalisés, appuyez sur le bouton 'Personnalisé'.",
	RG_PP_TOOLTIP1 = "Pour utiliser un portrait personnalisé, placez le fichier du portrait dans 'Documents/Baldur's Gate - Enhanced Edition/portraits' (vous devrez peut-être créer le dossier 'portraits' vous-même). L'image doit être au format BMP en 24-bit, et le nom du fichier ne doit pas dépasser sept caractères.",
	RG_PP_TOOLTIP2 = "Notez que les dimensions standard pour les portraits sont en 210x330. Les images plus grandes ou plus petites seront redimensionnées pour s'adapter à leur cadre. Les images ne peuvent pas dépasser 1024 dans l'une ou l'autre dimension.",
	RG_PP_TOOLTIP3 = "Pour mettre à jour votre liste de portraits, lancez le composant WeiDU 'Selecteur de Portrait' depuis le setup. Ajouter le préfixe 'f#' (pour femelle) ou 'm#' (pour mâle) au nom du fichier du portrait avant de lancer le programme WeiDU assignera automatiquement le genre du portrait. Les fichiers de portraits qui se terminent par 'm' ou 's' ne seront pas affichés dans la liste. En revanche, si le nom du fichier se termine par 'l' et qu'un autre fichier avec l'exact même nom mais se termine par 'm', ce dernier sera utilisé comme petit portrait dans la barre latérale droite. Pour ajouter une description et définir le genre manuellement, vous pourrez utiliser le 'Selecteur de portrait', qui sera bientôt disponible.",
	RG_PP_TOOLTIP4 = "Si vous voulez donner une description aux portraits par défaut, vous devrez modifier manuellement le fichier M_nicks.lua en trouvant le nom du fichier sur la gauche et en modifiant la description à côté entre les guillemets.",
	RG_CURRENT_QUESTS = "Quêtes en cours",
	RG_FINISHED_QUESTS = "Quêtes terminées",
	RG_TOTAL = "Total",
	RG_SPELL_TOOLTIP = "Utilisez le clic gauche pour mémoriser et le clic droit pour oublier.",
	RG_FILTER1 = "Filtrer par nom de personnage",
	RG_FILTER2 = "Filtrer par nom de sauvegarde",
	RG_FILTER3 = "Filtrer par chapitre",
	RG_UI_SETTINGS = "Paramètres de l'interface",
	RG_UI_CLASSIC_DIALOG = "Fenêtre de dialogue classique",
	RG_UI_CLASSIC_DIALOG1 = "Activer cette option affichera une fenêtre de dialogue immobile en bas au centre de l'écran, que vous pouvez défiler vers le haut pour voir l'historique du dialogue.",
	RG_UI_DIALOG_DISABLE_SPACE = "Désactive l'utilisation de la barre d'espace pendant les conversations",
	RG_UI_DIALOG_DISABLE_SPACE_HELP = "",
	RG_UI_MPPICKER = "Grand sélecteur de portrait",
	RG_UI_MPPICKER1 = "Activer cette option permettra d'afficher une grande sélection de portrait sur l'écran création de personnage, à la place de la liste par défaut.",
	RG_UI_LEFTPORTRAITS = "Portraits à gauche",
	RG_UI_LEFTPORTRAITS1 = "Activer cette option affichera les portrait à gauche de l'écran.",
	RG_UI_LPORTRAITS = "Portraits plus large",
	RG_UI_LPORTRAITS1 = "Activer cette option permettra d'afficher des portraits plus grand en jeu. À la place de la résolution habituelle de 64x91, ils seront en 82x123. Cette option convient principalement aux interfaces sans échelles.",										 																								  									 																																																				   
	RG_UI_THIEFBUTT = "Bouton permanent pour les actions de voleur",
	RG_UI_THIEFBUTT1 = "Activer cette option affichera un bouton permanent pour activer les actions de voleur en bas à gauche de l'écran. Cette option est utile pour les Clercs/Voleurs.",
	RG_UI_THIEFBUTT_WARN = "Nécessite une touche assignée pour les actions de voleur.",
	RG_UI_COMPARE_EQUIPMENT = "Comparaison de l'équipement",
	RG_UI_COMPARE_EQUIPMENT_HELP = "Activer cette option rend disponible la comparaison de l'équipement dans l'écran d'inventaire.",
	RG_UI_ONE_CLICK_TRAVEL = "Voyager en un seul clic",
	RG_UI_ONE_CLICK_TRAVEL_HELP = "En activant cette option, vous pourrez vous déplacer sur la carte du monde d'un simple clic sur la zone choisie.",
	RG_UI_CLOSE_MAP_ON_RMB = "Clic droit pour quitter la carte du monde",
	RG_UI_CLOSE_MAP_ON_RMB_HELP = "En activant cette option, vous pouvez fermer la carte du monde avec un simple clic à droite de votre souris.",
	RG_ABILITY_BONUSES = 'Bonus de caractéristiques',										
	RG_MENU_BG1_CAMPAIGN = "Campagnes de Baldur's Gate EE",
	RG_MENU_BG1_CAMPAIGN1 = "Baldur's Gate",
	RG_MENU_BG1_CAMPAIGN2 = "Le Siège de Vougedragon",
	RG_MENU_BG1_CAMPAIGN3 = "Les Fosses Noires",
	RG_MENU_BG2_CAMPAIGN = "Campagnes de Baldur's Gate 2 EE",
	RG_MENU_BG2_CAMPAIGN1 = "Les Ombres de l'Amn",
	RG_MENU_BG2_CAMPAIGN2 = "Le Trône de Bhaal",
	RG_MENU_BG2_CAMPAIGN3 = "Les Fosses Noires 2",
	RG_MENU_IWD_CAMPAIGN = "Campagnes de Icewind Dale EE",
	RG_MENU_IWD_CAMPAIGN1 = "Icewind Dale",
	RG_MENU_IWD_CAMPAIGN2 = "Heart of Winter",
}