import SwiftUI
import Combine

struct Destination: Identifiable {
    let id = UUID()
    let name: String
    let anecdote: String
}

struct ContentView: View {
    @State private var searchCity = ""
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var weatherData: [String: WeatherInfo] = [:]
    let apiKey = "e542525f50e6403381180038231906"
    @State private var cancellables = Set<AnyCancellable>()
// les anecdotes qu'on aurai pu mettre dans des fonctions et les recuperer
    
    let destinations: [Destination] = [Destination(name: "Paris", anecdote: "Paris est connue comme la ville de l'amour et abrite la célèbre tour Eiffel. Il y a des pickpockets donc attention où vous mettez les pieds. 😄"),
                                        Destination(name: "Lille", anecdote: "Lille est une ville animée du nord de la France, connue pour sa grande place et ses spécialités culinaires comme le fromage. 😊"),
                                        Destination(name: "Marseille", anecdote: "Marseille est une ville portuaire située dans le sud de la France, célèbre pour sa cuisine méditerranéenne et ses calanques. C'est une ville dynamique notamment pour son magnifique quartier 13 à visiter. 😉"),
                                        Destination(name: "Montpellier", anecdote: "Montpellier est une ville étudiante dynamique du sud de la France, avec un centre historique pittoresque. 😃"),
                                        Destination(name: "Nantes", anecdote: "Nantes est une ville artistique de l'ouest de la France, célèbre pour ses machines de l'île et son château des ducs de Bretagne. 😄"),
                                        Destination(name: "Tours", anecdote: "Tours est une charmante ville de la vallée de la Loire, réputée pour ses châteaux et ses vins. Une ville dynamique. 😊"),
                                        Destination(name: "Barcelone", anecdote: "Barcelone est une ville dynamique en Espagne, connue pour son architecture unique, notamment la Sagrada Família. 😃"),
                                        Destination(name: "Rome", anecdote: "Rome est la capitale de l'Italie et abrite de nombreux sites historiques, dont le Colisée et la basilique Saint-Pierre. 😄"),
                                        Destination(name: "Lisbonne", anecdote: "Lisbonne est la capitale du Portugal et est célèbre pour ses rues pavées, ses tramways colorés et ses délicieux pasteis de nata. 😊"),
                                        Destination(name: "New York", anecdote: "New York est une ville vibrante aux États-Unis, connue pour ses gratte-ciel emblématiques, comme l'Empire State Building et Times Square. 😃"),
                                        Destination(name: "Sydney", anecdote: "Sydney est la plus grande ville d'Australie, avec son célèbre opéra et son pont du port de Sydney. 😉"),
                                        Destination(name: "Tokyo", anecdote: "Tokyo est la capitale du Japon, une métropole moderne et animée où vous pouvez trouver des robots, des sushis délicieux et des quartiers branchés comme Shibuya et Shinjuku. 🇯🇵😄"),
                                        Destination(name: "Berlin", anecdote: "Berlin est la capitale de l'Allemagne et offre une scène artistique et culturelle dynamique, ainsi qu'une histoire fascinante marquée par le mur de Berlin et le Brandebourg. 🇩🇪😊"),
                                        Destination(name: "Londres", anecdote: "Londres est la capitale du Royaume-Uni, une ville cosmopolite avec des attractions emblématiques telles que Big Ben, le London Eye et le palais de Buckingham. 🇬🇧😃"),
                                        Destination(name: "Amsterdam", anecdote: "Amsterdam est la capitale des Pays-Bas, célèbre pour ses canaux pittoresques, ses musées renommés comme le Rijksmuseum et sa culture du vélo. 🇳🇱😄"),
                                        Destination(name: "Séoul", anecdote: "Séoul est la capitale de la Corée du Sud, une ville moderne où la technologie de pointe rencontre la tradition, avec des palais magnifiques, des marchés animés et une scène culinaire délicieuse. 🇰🇷😊"),
                                        Destination(name: "Rio de Janeiro", anecdote: "Rio de Janeiro est une ville brésilienne réputée pour ses plages légendaires comme Copacabana et Ipanema, ainsi que pour le célèbre carnaval de Rio qui attire des millions de visiteurs chaque année. 🇧🇷😃"),
                                        Destination(name: "Bangkok", anecdote: "Bangkok est la capitale de la Thaïlande, une ville animée où vous pouvez explorer des temples magnifiques, goûter une cuisine épicée et découvrir l'animation des marchés flottants. 🇹🇭😄"),
                                        Destination(name: "Le Caire", anecdote: "Le Caire est la capitale de l'Égypte et abrite les pyramides de Gizeh, des merveilles antiques qui fascinent les voyageurs du monde entier. 🇪🇬😊"),
                                        Destination(name: "Moscou", anecdote: "Moscou est la capitale de la Russie, avec des sites emblématiques tels que la place Rouge, le Kremlin et la célèbre cathédrale Saint-Basile. 🇷🇺😃"),
                                        Destination(name: "Mexico", anecdote: "Mexico est la capitale du Mexique, une métropole dynamique où vous pouvez déguster de délicieux tacos, explorer des sites archéologiques tels que Teotihuacan et découvrir la riche culture mexicaine. 🇲🇽😄"),
                                        Destination(name: "Le Cap", anecdote: "Le Cap est une ville sud-africaine magnifique située à l'extrémité de la péninsule du Cap, offrant des paysages à couper le souffle, une faune incroyable et une histoire fascinante. 🇿🇦😊"),
                                        Destination(name: "Buenos Aires", anecdote: "Buenos Aires est la capitale de l'Argentine, une ville réputée pour le tango, les steaks succulents et une vie nocturne animée. 🇦🇷😃"),
                                        Destination(name: "Vienne", anecdote: "Vienne est la capitale de l'Autriche et est connue pour son architecture élégante, ses délices culinaires tels que les sachertortes et sa scène musicale raffinée avec l'opéra de Vienne. 🇦🇹😄"),
                                        Destination(name: "Delhi", anecdote: "Delhi est la capitale de l'Inde, une ville dynamique où l'ancien et le moderne se rencontrent, avec des monuments emblématiques tels que le Fort Rouge, la porte de l'Inde et le Taj Mahal à proximité. 🇮🇳😊"),
                                        Destination(name: "Budapest", anecdote: "Budapest est la capitale de la Hongrie, une ville pittoresque traversée par le fleuve Danube, avec des bains thermaux relaxants, un riche héritage historique et une architecture magnifique. 🇭🇺😃"),
                                        Destination(name: "Dublin", anecdote: "Dublin est la capitale de l'Irlande, une ville conviviale réputée pour ses pubs animés, sa musique traditionnelle, ses monuments historiques et sa célèbre bière Guinness. 🇮🇪😄"),
                                        Destination(name: "Athènes", anecdote: "Athènes est la capitale de la Grèce et est célèbre pour ses sites antiques tels que l'Acropole, le Parthénon et le théâtre de Dionysos, ainsi que pour sa cuisine délicieuse et ses ruelles pittoresques. 🇬🇷😊"),
                                        Destination(name: "Zurich", anecdote: "Zurich est la plus grande ville de Suisse, connue pour ses paysages alpins époustouflants, sa propreté impeccable, ses chocolats délicieux et sa qualité de vie élevée. 🇨🇭😃"),
                                        Destination(name: "Hawaï", anecdote: "Hawaï est un archipel américain situé dans l'océan Pacifique, célèbre pour ses plages de sable blanc, ses volcans actifs, sa culture polynésienne et ses couchers de soleil spectaculaires. 🌺🌴😄"),
                                        Destination(name: "Copenhague", anecdote: "Copenhague est la capitale du Danemark, une ville moderne et écologique, réputée pour son design scandinave, ses vélos omniprésents et son parc d'attractions mondialement connu, Tivoli Gardens. 🇩🇰😊"),
                                        Destination(name: "Saint-Pétersbourg", anecdote: "Saint-Pétersbourg est la deuxième plus grande ville de Russie, réputée pour ses palais somptueux, ses canaux romantiques, ses musées renommés tels que l'Ermitage et son atmosphère culturelle riche. 🇷🇺😃"),
                                        Destination(name: "Prague", anecdote: "Prague est la capitale de la République tchèque, une ville magique aux allures de conte de fées avec son château majestueux, son pont Charles et sa bière délicieuse. 🇨🇿😄"),
                                        Destination(name: "Stockholm", anecdote: "Stockholm est la capitale de la Suède, une ville réputée pour son design élégant, ses îles pittoresques, son archipel magnifique et sa scène musicale florissante. 🇸🇪😊"),
                                        Destination(name: "Vancouver", anecdote: "Vancouver est une ville canadienne située en Colombie-Britannique, entourée de montagnes majestueuses, d'océan et de parcs naturels. C'est une ville cosmopolite avec une qualité de vie exceptionnelle. 🇨🇦😃"),
                                        Destination(name: "Singapour", anecdote: "Singapour est un État insulaire situé en Asie du Sud-Est, célèbre pour son architecture futuriste, sa propreté impeccable, sa cuisine délicieuse et ses jardins botaniques luxuriants. 🇸🇬😄"),
                                        Destination(name: "Reykjavik", anecdote: "Reykjavik est la capitale de l'Islande, une ville située au milieu de paysages spectaculaires, avec ses sources chaudes, ses aurores boréales et sa culture unique. 🇮🇸😊"),
                                        Destination(name: "Toronto", anecdote: "Toronto, la ville où la tour CN domine l'horizon, les feuilles d'érable peignent l'automne et le multiculturalisme est célébré ! 🏙️🍁🌍"),
                                        Destination(name: "Dubai", anecdote: "Dubai, la ville où les gratte-ciels défient le ciel, le désert s'étend à perte de vue et le luxe est une seconde nature ! Attention au mangeur de caca 🌆🏜️💎"),
                                        Destination(name: "Helsinki", anecdote: "Helsinki, la ville où le design est une forme de vie, les saunas réchauffent l'âme et les nuits d'été sont éternellement lumineuses ! 🎨🔥☀️"),
                                        Destination(name: "Bruxelles", anecdote: "Bruxelles, la ville où les gaufres sont aussi douces que le chocolat est délicieux et où l'Atomium scintille de mille feux ! 🧇🍫✨"),
                                        Destination(name: "Oslo", anecdote: "Oslo, la ville où la nature et l'urbanisme cohabitent, les musées racontent l'histoire des Vikings et les fjords invitent à l'aventure ! 🌲⚔️🏞️"),
                                        Destination(name: "Madrid", anecdote: "Madrid, la ville où le soleil brille souvent, le flamenco enflamme les nuits et les tapas sont un art de vivre ! ☀️💃🍤"),
                                        Destination(name: "Beyrouth", anecdote: "Beyrouth, la ville où l'histoire ancienne rencontre le moderne, la cuisine libanaise fait vibrer les papilles et la vie nocturne est légendaire ! 🏛️🥙🎉"),
                                        Destination(name: "Santiago", anecdote: "Santiago, la ville où les montagnes embrassent le ciel, le vin est une passion et la salsa anime les rues ! 🏔️🍷💃"),
                                        Destination(name: "Istanbul", anecdote: "Istanbul, la ville où deux continents se rencontrent, les mosquées illuminent le ciel et les bazars sont un festival de couleurs et de saveurs ! 🌉🕌🛍️"),
                                        Destination(name: "Marrakech", anecdote: "Marrakech, la ville des souks animés, des palais majestueux et des jardins luxuriants où l'on se perd dans les senteurs d'épices ! 🛍️🏰🌿"),
                                        Destination(name: "Beijing", anecdote: "Beijing, la ville où l'histoire ancienne rencontre le futur, les hutongs dévoilent la vie locale et le canard laqué est une délice royal ! 🏮🍜🦆"),
                                        Destination(name: "Casablanca", anecdote: "Casablanca, la ville où l'art déco se mélange à la culture marocaine, le thé à la menthe est une invitation à la détente et la mosquée Hassan II brille sur l'océan ! 🏛️☕🕌"),
                                        Destination(name: "Hanoi", anecdote: "Hanoi, la ville où le lac Hoan Kiem raconte des légendes, les pho réchauffent les cœurs et les marchés de rue débordent de vie ! 🌊🍲🏮"),
                                        Destination(name: "Kuala Lumpur", anecdote: "Kuala Lumpur, la ville où les Tours Petronas dominent le ciel, les marchés nocturnes sont un festival de saveurs et les temples hindous ajoutent des touches de couleurs vives ! 🏙️🍛🕌"),
                                        Destination(name: "Jakarta", anecdote: "Jakarta, la ville où le moderne rencontre le traditionnel, les rues sont remplies de warung et le gamelan résonne dans l'air ! 🏙️🍲🎵"),
                                        Destination(name: "Las Vegas", anecdote: "Las Vegas, la ville où les lumières ne s'éteignent jamais, le jeu est un art de vivre et les spectacles sont aussi spectaculaires que diversifiés ! 🌃🎰🎭"),
                                        Destination(name: "Edinburgh", anecdote: "Edinburgh, la ville où l'histoire est gravée dans la pierre, les festivals animent les rues et le whisky est une tradition sacrée ! 🏰🎭🥃"),
                                        Destination(name: "Shanghai", anecdote: "Shanghai, la ville où l'Est rencontre l'Ouest, les gratte-ciels touchent le ciel et les xiaolongbao sont un délice à savourer ! 🏙️🏮🥟"),
                                        Destination(name: "Cape Town", anecdote: "Cape Town, la ville où la montagne rencontre la mer, les pingouins se prélassent sur la plage et la culture du vin est une véritable tradition ! 🌄🐧🍷"),
                                        Destination(name: "Courchevel", anecdote: "Courchevel, la ville où le luxe rencontre les sports d'hiver, les chalets sont des havres de paix et la fondue est une récompense après une journée sur les pistes ! 🏔️🏰🧀"),
                                           Destination(name: "Queenstown", anecdote: "Queenstown, la ville où l'aventure est à chaque coin de rue, les paysages sont à couper le souffle et les sports d'hiver sont rois ! 🏞️🏔️🏂"),
                                           Destination(name: "Grenoble", anecdote: "Grenoble, la ville où la science rencontre la montagne, les bulles volent dans le ciel et la Chartreuse est une véritable institution ! 🏔️🔬🍸"),
                                           Destination(name: "Lourdes", anecdote: "Lourdes, la ville nichée au pied des Pyrénées, où la spiritualité rencontre la beauté naturelle et où la grotte de Massabielle fascine les pèlerins ! 🏔️🙏💦"),
                                           Destination(name: "Innsbruck", anecdote: "Innsbruck, la ville où l'architecture médiévale rencontre les Alpes, le tremplin de saut à ski est un monument emblématique et le strudel aux pommes est un délice à savourer ! 🏔️🏰🥧"),
                                        Destination(name: "Zurich", anecdote: "Zurich, la ville où l'horlogerie est une véritable passion, où les montagnes offrent des paysages à couper le souffle et où le chocolat suisse est une véritable tentation pour les gourmands ! ⌚🏔️🍫"),
                                       Destination(name: "Lens", anecdote: "Lens est une ville charmante située dans le nord de la France"),
                                       Destination(name: "Sevran", anecdote: "La ville des fous fait belek !!!!!!!"),
                                       Destination(name: "Strasbourg", anecdote: "Strasbourg est une ville cosmopolite avec une richesse culturelle impressionnante. Vous y trouverez la Cathédrale de Notre-Dame, l'une des plus hautes constructions du Moyen Âge. Oh, et n'oubliez pas le marché de Noël - c'est magique! 🎄😊"),

                                       Destination(name: "Le Mans", anecdote: "Amoureux de voitures, bienvenue au Mans! Cette ville est célèbre pour sa course d'endurance de 24 heures. N'oubliez pas votre casquette et vos lunettes de soleil! 🏎️😎"),

                                       Destination(name: "Colombes", anecdote: "Colombes est une ville charmante, surtout si vous aimez le rugby! Elle abrite le stade Olympique Yves-du-Manoir. Peut-être aurez-vous la chance de voir un match des 'Colombes'! 🏉😃"),

                                       Destination(name: "Versailles", anecdote: "À Versailles, vous pourrez admirer le château le plus luxueux de France. Préparez-vous à marcher - le jardin est immense! Ne manquez pas le spectacle des fontaines, c'est une danse d'eau inoubliable! 🏰💃"),

                                       Destination(name: "Cannes", anecdote: "Cannes n'est pas seulement célèbre pour son festival de cinéma, elle offre également de superbes plages. Alors, apportez votre crème solaire et votre glamour à Cannes! 🎬👒"),

                                       Destination(name: "Grasse", anecdote: "Si vous aimez les parfums, Grasse est l'endroit à visiter! C'est la capitale mondiale du parfum, alors préparez-vous à un voyage sensoriel incroyable. Ne manquez pas de créer votre propre parfum! 🌺👃"),

                                       Destination(name: "Rennes", anecdote: "Rennes est une ville dynamique avec une vie nocturne animée. Amateurs de musique et de festivals, c'est l'endroit pour vous! Et ne manquez pas les crêpes bretonnes, elles sont délicieuses! 🎶😋"),

                                       Destination(name: "Le Havre", anecdote: "Le Havre est une ville portuaire fascinante avec une architecture moderne unique, déclarée patrimoine mondial de l'UNESCO. N'oubliez pas de visiter le Musée d'Art Moderne André Malraux - la vue sur la mer est sublime! 🏢🌊"),
                                       Destination(name: "Sarajevo", anecdote: "Sarajevo est une ville pleine de contrastes et d'histoire. Connue pour son riche héritage culturel, cette ville est souvent appelée la 'Jérusalem de l'Europe' en raison de sa diversité religieuse. Attention, ici, il n'est pas recommandé de porter des vêtements multicolores en raison de certaines coutumes locales. Essayez le burek et le café bosniaque, vous ne le regretterez pas! ☕😊"),
                                       Destination(name: "Aubervilliers", anecdote: "Aubervilliers est un melting-pot vibrant d'art et de culture urbaine. Là-bas, vous pouvez sentir le vrai rythme de la rue. Entre les graffitis colorés et les concerts improvisés, chaque coin de rue peut être une surprise ( pour les agressions hehe) ! 🎨🎶"),
                                       
                                       Destination(name: "Argenteuil", anecdote: "Argenteuil est une ville qui a du caractère! Avec ses parcs urbains et ses festivals de rue, c'est un véritable témoignage du dynamisme de la culture de banlieue. Et oui, c'est aussi la ville qui a inspiré le célèbre Monet pour ses peintures de paysages. 🏞️🖌️... Nan on rigole FAIT BELEEEEEEEEEEEEEEK"),
                                       Destination(name: "Camille", anecdote: "C'est la ville des folles 💃💃💃💃💃💃💃💃💃"),
                                       Destination(name: "Dunkerque", anecdote: "Dunkerque est célèbre pour son carnaval haut en couleur qui se déroule chaque année. C'est également un lieu d'histoire, connu pour l'Opération Dynamo de la Seconde Guerre Mondiale. Attention à la joyeuse folie du carnaval ! 🎭🥳"),

                                       Destination(name: "Orléans", anecdote: "Orléans, c'est la ville de Jeanne d'Arc, l'héroïne de la France. Ne manquez pas de visiter la maison qui lui est dédiée. Et puis, il y a le Festival de la Loire, un grand rassemblement de la marine fluviale. Le paysage sur les bords de la Loire est tout simplement époustouflant. 🏞️😃"),

                                       Destination(name: "Valence", anecdote: "Valence est une ville qui sent bon la Méditerranée. Entre les champs d'orangers et la mer azur, c'est un endroit idyllique pour les amoureux de la nature. Sans oublier la paella, bien sûr, délicieuse! 🥘🌊"),

                                       Destination(name: "Séville", anecdote: "Séville est le cœur battant de l'Andalousie. Connue pour sa cathédrale gothique, son Alcazar de style mauresque et bien sûr, le flamenco. C'est une ville qui danse, qui chante et qui vit avec passion. Ole! 💃🌞"),
    
                                    Destination(name: "Melbourne", anecdote: "Melbourne est la capitale culturelle de l'Australie. Entre galeries d'art, concerts et cafés hipster, il y a toujours quelque chose à faire. Et puis, il y a les tramways, une charmante façon de découvrir la ville. 🚃🎨"),
    
                                    Destination(name: "Kyoto", anecdote: "Kyoto est le cœur historique du Japon. Avec ses temples anciens, ses jardins zen et ses maisons de thé, c'est une ville où le temps semble s'être arrêté. Et si vous avez de la chance, vous pourrez voir une vraie geisha dans le quartier de Gion. 🏮🍵"),
    
                                       Destination(name: "Antony", anecdote: "Antony est une ville charmante, surtout connue pour le Parc de Sceaux, qui abrite un château, un immense jardin et un musée. C'est un endroit parfait pour une journée tranquille au vert, tout en restant à proximité de l'agitation de la capitale. Ne manquez pas la floraison des cerisiers au printemps - c'est une véritable féerie! 🌸😊"),
                                       Destination(name: "Lyon", anecdote: "Lyon est réputée pour être la capitale de la gastronomie française, avec ses bouchons lyonnais et la fameuse quenelle. C'est aussi la ville des lumières, avec son festival annuel qui transforme la ville en un spectacle féerique. PS: C'est aussi la ville qui abrite le Groupama Stadium, un endroit incroyable pour tous les fans de football. Bref la meilleure ville de la planete IMO. AHOUUUUUU ! Allez l'OL ! ⚽🦁"),
                                       Destination(name: "Alexis", anecdote: " Une ville qui à 0 anecdote, 0 coutumes , sans histoire , pauvre , comme un certain Alexis D"),
                                       Destination(name: "Perpignan", anecdote: "Perpignan est une ville aux influences catalanes marquées. Là-bas, ne manquez pas le Castillet, ancienne porte de la ville. Et si vous aimez l'art, le Centre d'Art Contemporain Walter Benjamin vaut le détour! 🎨🏰"),

                                       Destination(name: "Sarcelles", anecdote: "Sarcelles est une ville dynamique de la banlieue parisienne. Elle est connue pour sa diversité culturelle et son engagement en faveur de l'éducation et de la jeunesse. C'est une véritable mosaïque de cultures! PS il y a l'ancien pote de Mahrez et la gare incroyable. EN SCREEEEED 🌍🤝"),

                                       Destination(name: "Grigny", anecdote: "Grigny, dans l'Essonne, est une ville pleine de vie avec une forte implication dans le développement social et urbain. Et si vous aimez la nature, le parc Pierre à Masse est un havre de paix (enfin ... sa dépend pour qui). 🏞️🌳"),

                                       Destination(name: "Bondy", anecdote: "Bondy est une ville de la banlieue parisienne, connue pour son dynamisme et ses talents sportifs. C'est ici que le célèbre footballeur Kylian Mbappé a fait ses débuts! ⚽️🌟"),

                                       Destination(name: "Bordeaux", anecdote: "Bordeaux, c'est la capitale du vin! Profitez d'une balade le long de la Garonne et d'une visite de la Cité du Vin. Et n'oubliez pas d'essayer le canelé, une spécialité locale délicieuse! 🍷🍮"),

                                       Destination(name: "Rabat", anecdote: "Rabat est la capitale du Maroc, connue pour ses monuments historiques tels que la Tour Hassan et le Mausolée Mohammed V. Sans oublier le jardin des Oudayas, un véritable havre de paix. 🕌🌴"),

                                       Destination(name: "Sousse", anecdote: "Sousse, en Tunisie, est une ville balnéaire avec une histoire riche. Vous pouvez vous promener dans la médina et visiter le Ribat, un ancien fort. Et la plage est toujours à proximité pour un moment de détente! 🏖️🌞"),

                                       Destination(name: "Bilbao", anecdote: "Bilbao, en Espagne, est une ville d'art et d'architecture. Le musée Guggenheim est un incontournable, tout comme les pintxos, les tapas basques. Miam! 🎨🍤"),

                                       Destination(name: "Neuilly", anecdote: "Neuilly-sur-Seine est une élégante banlieue de Paris, connue pour ses belles demeures et son ambiance chic. Le Parc de Bagatelle est un endroit parfait pour une promenade tranquille. 🏡🌷"),
                                       Destination(name: "Rouen", anecdote: "Rouen est une ville historique célèbre pour sa cathédrale gothique qui a inspiré de nombreuses peintures de Monet. C'est aussi ici que Jeanne d'Arc a été jugée et brûlée sur le bûcher. Prenez le temps de flâner dans ses rues médiévales. 🏰🎨"),

                                       Destination(name: "Lorient", anecdote: "Lorient, sur la côte bretonne, est connu pour son festival interceltique qui attire chaque année des milliers de personnes. Entre les danses traditionnelles et les concerts de musique celtique, vous aurez l'impression d'être au cœur d'une grande fête familiale. 🎶🕺"),

                                       Destination(name: "Ventimille", anecdote: "Ventimille, ou Ventimiglia en Italien, est une charmante ville de la Riviera Italienne. Elle est célèbre pour son marché du vendredi où vous pouvez acheter de tout, des produits locaux aux vêtements de marque. Attention aux bonnes affaires ! 🛍️🍋"),

                                       Destination(name: "Florence", anecdote: "Florence est le berceau de la Renaissance. Avec ses musées, dont la Galerie des Offices, et ses bâtiments historiques comme le Duomo, cette ville est un véritable musée à ciel ouvert. Ne manquez pas de goûter au gelato, c'est une vraie délice ! 🍨🎨"),

                                       Destination(name: "Venise", anecdote: "Venise est la ville des gondoles et des canaux. Connue pour son carnaval et son festival de cinéma, c'est une ville où le romantisme est partout. Mais n'oubliez pas, ici, il est préférable de se perdre dans les petites ruelles plutôt que de suivre les grands canaux. C'est là que se cachent les véritables trésors de Venise. 🛶🎭"),
                                       Destination(name: "Arctic Bay", anecdote: "Arctic Bay est l'une des communautés les plus au nord du Canada. C'est un endroit idéal pour observer les aurores boréales et la faune arctique. N'oubliez pas votre parka, il fait très froid ici, même en été! ❄️🌌"),
                                       Destination(name: "Eindhoven", anecdote: "Eindhoven est souvent appelée la 'Silicon Valley' des Pays-Bas. C'est un centre d'innovation et de technologie, abritant le siège de Philips et une université de technologie de renom. Ne manquez pas le festival GLOW, où l'art de la lumière transforme la ville en un spectacle étincelant. 💡🔬"),

                                       Destination(name: "Boston", anecdote: "Boston est une ville riche en histoire américaine. Marchez sur le Freedom Trail, visitez Harvard, et ne manquez pas une partie de baseball des Red Sox au Fenway Park. Et oui, ici, les accents de Boston sont aussi forts que le café! ⚾🎓"),

                                       Destination(name: "Saint-Tropez", anecdote: "Saint-Tropez, une ville connue pour sa jet-set et ses plages de sable fin. C'est l'endroit parfait pour les amateurs de soleil et de glamour. N'oubliez pas vos lunettes de soleil et votre maillot de bain, vous allez briller! 🏖️🕶️"),

                                       Destination(name: "Pau", anecdote: "Pau est une ville charmante du sud-ouest de la France, célèbre pour son boulevard des Pyrénées offrant une vue imprenable sur la chaîne de montagnes. Et oui, c'est aussi la ville natale de Henri IV, le bon roi Henri! 🏞️👑"),

                                       Destination(name: "Saint-Étienne", anecdote: "Saint-Étienne est une ville dynamique, célèbre pour son équipe de football et son design innovant. Elle a été désignée Ville de Design par l'UNESCO. Si vous êtes fan de foot et de créativité, c'est l'endroit pour vous! ⚽🎨"),

                                       Destination(name: "Clermont-Ferrand", anecdote: "Clermont-Ferrand est la ville des volcans ! Nichée au cœur de la chaîne des Puys, elle est célèbre pour son fromage et son festival international du court-métrage. Et n'oubliez pas de visiter la cathédrale en pierre de lave noire. 🌋🧀"),

                                       Destination(name: "Pise", anecdote: "Pise, c'est bien sûr la ville de la fameuse Tour Penchée. Ne manquez pas de faire la photo classique où vous 'soutenez' la tour! Mais Pise, c'est aussi une ville universitaire animée avec une architecture magnifique. 📸🏛️"),
                                       Destination(name: "Porto", anecdote: "Porto est une ville charmante au bord de la rivière Douro, célèbre pour ses caves à vin de porto. Prenez le temps de flâner dans la Ribeira, le vieux quartier de la ville. Et ne manquez pas un voyage sur le fleuve, la vue sur les rives est magnifique. 🍷🚤"),
                                       Destination(name: "Manchester", anecdote: "Manchester est une ville qui bat au rythme du football et de la musique. C'est la maison des équipes de football rivales Manchester United et Manchester City, ainsi que le berceau de groupes légendaires comme The Smiths et Oasis. Ne manquez pas le musée de la Science et de l'Industrie! ⚽🎸"),

                                       Destination(name: "Liverpool", anecdote: "Liverpool est célèbre pour deux choses : le football et les Beatles. Visitez le musée des Beatles, promenez-vous sur Penny Lane et assistez à un match de football à Anfield. Et n'oubliez pas de faire un tour en ferry sur la Mersey. ⚽🎵"),

                                       Destination(name: "Bath", anecdote: "Bath est une ville historique connue pour ses thermes romains parfaitement conservés et son architecture georgienne, notamment le Royal Crescent. C'est aussi la ville de Jane Austen, alors pourquoi ne pas se plonger dans l'époque de l'Orgueil et Préjugés ? 🛁📚"),

                                       Destination(name: "Oxford", anecdote: "Oxford est une ville empreinte d'histoire et de savoir. Promenez-vous dans les magnifiques collèges de l'université d'Oxford, découvrez les trésors de la Bodleian Library et essayez le punting sur la rivière Cherwell. Et oui, c'est ici que de nombreux scènes de Harry Potter ont été tournées! 🎓🧙‍♂️"),

                                       Destination(name: "Cambridge", anecdote: "Cambridge est une autre ville universitaire pleine de charme. Des collèges historiques à la beauté tranquille des Backs, c'est une ville qui invite à la rêverie. Et bien sûr, essayez le punting sur la rivière Cam, c'est une tradition! 🚣‍♀️🏛️"),
                                       Destination(name: "Cancun", anecdote: "Cancún, au Mexique, est une destination de vacances populaire pour ses plages de sable blanc et son eau bleue turquoise. Explorez les ruines mayas à proximité, plongez dans les cénotes et profitez de la vie nocturne animée. 🌴🌞"),

                                       Destination(name: "Orlando", anecdote: "Orlando en Floride est connue comme la capitale mondiale des parcs à thème. De Disney World à Universal Studios, il y a de quoi occuper toute la famille. Et n'oubliez pas de visiter le Kennedy Space Center! 🎢🚀"),
                                       Destination(name: "Santorini", anecdote: "Santorini en Grèce est célèbre pour ses maisons blanches aux toits bleus, ses magnifiques couchers de soleil et ses plages de sable noir. C'est une destination de vacances idéale pour ceux qui cherchent à se détendre et à profiter de la beauté naturelle. 🏖️🌅"),
                                       Destination(name: "Machu Picchu", anecdote: "Bien que ce ne soit pas une ville à proprement parler, Machu Picchu au Pérou est un incontournable en Amérique du Sud. Cette ancienne cité inca perchée sur une crête de montagne est l'un des sites archéologiques les plus célèbres au monde. 🗻🏞️"),

                                       Destination(name: "Cartagena", anecdote: "Cartagena en Colombie est une ville coloniale vibrante, connue pour ses remparts bien préservés, ses rues pavées et ses maisons colorées. Promenez-vous dans la vieille ville, essayez la cuisine locale et profitez de la musique en direct dans les places animées. 🎶🌴"),
                                       Destination(name: "Deauville", anecdote: "Deauville est une destination chic sur la côte normande de la France, connue pour son festival du film américain, ses courses de chevaux et son casino. Marchez sur les célèbres Planches, le front de mer bordé de cabines de plage nommées d'après les stars de cinéma qui ont visité la ville. 🎬🏖️"),
                                       Destination(name: "Leipzig", anecdote: "Leipzig, souvent appelée la 'Petite Paris', est une ville d'art et de musique en Allemagne. C'est ici que Johann Sebastian Bach a passé une grande partie de sa vie professionnelle et que Felix Mendelssohn a fondé la première école de musique en Allemagne. Ne manquez pas le Gewandhaus et l'opéra de Leipzig. 🎶🎻"),

                                       Destination(name: "Varsovie", anecdote: "Varsovie est une ville qui a su se relever de ses cendres après la Seconde Guerre mondiale. Promenez-vous dans la vieille ville restaurée, visitez le musée de l'Insurrection de Varsovie et profitez de la vue depuis le Palais de la Culture et de la Science, un cadeau de Staline à la Pologne. 🏰🌆"),
                                       Destination(name: "Zagreb", anecdote: "Zagreb, la capitale de la Croatie, est une ville vibrante avec une scène artistique florissante. Ne manquez pas de visiter le musée des relations rompues et la cathédrale de Zagreb. Et si vous êtes là en été, essayez de vous rendre au festival d'été de Zagreb. 🎭🏛️"),

                                       Destination(name: "Split", anecdote: "Split est une ville côtière en Croatie, connue pour le palais de Dioclétien, un site du patrimoine mondial de l'UNESCO. Promenez-vous sur le Riva, un front de mer animé avec de nombreux cafés et boutiques. 🌅🏰"),

                                       Destination(name: "Dubrovnik", anecdote: "Dubrovnik, surnommée la 'Perle de l'Adriatique', est connue pour ses remparts impressionnants et ses ruelles pavées. C'est également ici qu'une partie de la série 'Game of Thrones' a été filmée. Et n'oubliez pas de prendre le téléphérique jusqu'au mont Srd pour une vue panoramique de la ville. 🚠🏞️"),
                                       Destination(name: "Jouy-en-Josas", anecdote: "Jouy-en-Josas est une petite commune pittoresque située dans la région des Yvelines, en Île-de-France. Connue pour son ancienne manufacture de toiles imprimées, c'est un havre de paix aux portes de Paris. Elle abrite également l'une des écoles de commerce les plus prestigieuses de France, HEC Paris. Ah, et un petit secret : notre ami Hugo vit ici. Alors si vous visitez, gardez un œil ouvert, vous pourriez le croiser (avec sa Mini délabrée et son tatouage chelou) ! 😄🏡"),
                                       Destination(name: "Los Angeles", anecdote: "Los Angeles est une métropole vibrante et diversifiée, connue pour son industrie du divertissement. Promenez-vous sur le Hollywood Walk of Fame, visitez les studios Universal, et n'oubliez pas de prendre une photo du célèbre signe Hollywood. Les amoureux de l'art peuvent visiter le Getty Center ou le LACMA, et si vous cherchez à vous détendre, passez la journée à la plage de Santa Monica ou de Venice. Et bien sûr, gardez un œil ouvert - vous pourriez apercevoir une célébrité! 🎬🏖️🌴"),
                                       Destination(name: "Vincennes", anecdote: "Vincennes est une commune située à l'est de Paris, connue pour son magnifique château médiéval - le Château de Vincennes - qui était autrefois la résidence des rois de France. La ville abrite également le Bois de Vincennes, le plus grand parc public de la ville, qui offre une variété d'activités de loisirs, dont la navigation de plaisance, le vélo, et même des spectacles de marionnettes. C'est un lieu idéal pour une évasion tranquille de l'agitation de Paris. 🏰🌳"),
                                       Destination(name: "Provence", anecdote: "La Provence est une région magnifique du sud-est de la France, connue pour ses champs de lavande parfumés, ses oliviers, ses vignobles et ses villages perchés. C'est la destination idéale pour ceux qui aiment la nature, la bonne cuisine et le vin. 🍇🌾"),

                                       Destination(name: "Avignon", anecdote: "Avignon, située en Provence, est célèbre pour le Palais des Papes, une gigantesque forteresse gothique qui servait de résidence aux papes au XIVe siècle. Chaque été, la ville accueille le Festival d'Avignon, un événement important du théâtre contemporain. 🏰🎭"),

                                       Destination(name: "Alexandrie", anecdote: "Alexandrie, en Égypte, était autrefois l'un des plus grands centres d'apprentissage du monde antique et abritait le phare légendaire d'Alexandrie, l'une des sept merveilles du monde. Aujourd'hui, vous pouvez explorer la bibliothèque moderne d'Alexandrie, inspirée de l'ancienne, et visiter le palais de Montaza. 📚🏛️"),

                                       Destination(name: "Santos", anecdote: "Santos, au Brésil, est le plus grand port d'Amérique latine. La ville est également célèbre pour son jardin de plage, reconnu par le Livre Guinness des records comme le plus grand jardin de plage du monde. Ne manquez pas le Musée du Café, qui raconte l'histoire de cette boisson adorée dans le pays. ☕️🏖️"),

                                       Destination(name: "Sao Paulo", anecdote: "Sao Paulo est l'une des plus grandes villes du monde et le centre économique du Brésil. La ville possède une scène culturelle diversifiée, avec des musées de premier plan comme le MASP, une cuisine internationale, une vie nocturne animée et une variété d'événements musicaux et sportifs. C'est une ville qui ne dort jamais. 🌃🍽️"),
                                       Destination(name: "Chicago", anecdote: "Chicago est célèbre pour son architecture impressionnante, y compris la Willis Tower (anciennement Sears Tower), l'une des structures les plus hautes du monde. Ne manquez pas de visiter le parc Millennium pour voir la Cloud Gate (communément appelée 'The Bean') et d'essayer une véritable pizza deep-dish. 🏢🍕"),

                                       Destination(name: "Miami", anecdote: "Miami est une destination prisée pour ses plages ensoleillées, son architecture Art déco colorée à South Beach et sa scène culinaire influencée par la culture cubaine. Les Everglades, un parc national unique en son genre, sont à une courte distance en voiture. 🌴🌞"),

                                       Destination(name: "San Francisco", anecdote: "San Francisco est connue pour le Golden Gate Bridge, ses maisons victoriennes colorées et ses trolley cars. Explorez le quartier de Fisherman's Wharf, promenez-vous dans le parc Golden Gate, et n'oubliez pas de visiter Alcatraz, l'ancienne prison insulaire. 🌉🚋"),
                                       Destination(name: "Cergy", anecdote: "Cergy est une ville nouvelle en région parisienne, connue pour son université, l'Université de Cergy-Pontoise. Elle est également appréciée pour son cadre de vie agréable avec de nombreux espaces verts et l'étendue d'eau de l'Axe Majeur, une œuvre d'art paysagiste. 🌳🎓"),

                                       Destination(name: "Cincinnati", anecdote: "Cincinnati, dans l'Ohio, est connue pour son architecture historique, notamment dans le quartier d'Over-the-Rhine. C'est également la ville d'origine du chili Cincinnati, un plat unique servi sur des spaghettis. Et n'oubliez pas de visiter le zoo de Cincinnati, l'un des plus anciens du pays. 🌭🦁"),

                                       Destination(name: "Caen", anecdote: "Caen, dans la région normande, a une histoire riche, en grande partie marquée par le D-Day pendant la Seconde Guerre mondiale. Visitez le Mémorial de Caen pour en savoir plus sur cette période. La ville abrite également un château médiéval fondé par Guillaume le Conquérant. 🏰🌺"),

                                       Destination(name: "Nancy", anecdote: "Nancy est célèbre pour sa place Stanislas, l'une des plus belles places royales d'Europe. La ville est également connue pour son école de l'Art nouveau et le musée de l'École de Nancy. Ne partez pas sans avoir goûté aux macarons de Nancy et à la bergamote, des spécialités locales. 🍬🖼️"),

                                       Destination(name: "Metz", anecdote: "Metz est une ville charmante de la région Grand Est, connue pour sa cathédrale Saint-Étienne avec ses magnifiques vitraux. La ville abrite également le Centre Pompidou-Metz, un musée d'art moderne et contemporain. 🎨🏛️"),

                                       Destination(name: "Ajaccio", anecdote: "Ajaccio, sur l'île de Corse, est la ville natale de Napoléon Bonaparte. Visitez la maison où il est né, maintenant un musée, et profitez des magnifiques plages de la région. La citadelle d'Ajaccio offre une belle vue sur le port. 🏖️🏰"),

                                       Destination(name: "Bastia", anecdote: "Bastia est une autre ville charmante de Corse, connue pour son vieux port coloré et ses rues étroites et sinueuses. Grimpez jusqu'à la citadelle pour une vue panoramique sur la ville et la mer. La région est également réputée pour ses vins. 🍷⛵"),
                                       Destination(name: "Rosario", anecdote: "Rosario, en Argentine, est la ville natale du révolutionnaire Che Guevara et du footballeur Lionel Messi. Elle est connue pour ses parcs le long du fleuve Paraná, ses bâtiments historiques et le Monumento a la Bandera, un monument impressionnant dédié au drapeau argentin. ⚽🇦🇷"),

                                       Destination(name: "Eibar", anecdote: "Eibar est une petite ville de la région basque en Espagne, connue pour son équipe de football, la SD Eibar. Malgré sa petite taille, la ville a une passion pour le football qui dépasse de loin celle de nombreuses villes plus grandes. ⚽🇪🇸"),

                                       Destination(name: "Saragosse", anecdote: "Saragosse, en Espagne, est connue pour la Basilique del Pilar, un grand temple baroque dédié à la Vierge Marie. La ville abrite également le Palais de l'Aljafería, un palais maure du XIe siècle. Saragosse est une ville riche en histoire et en culture. 🏰🇪🇸"),

                                       Destination(name: "Washington D.C.", anecdote: "Washington D.C., la capitale des États-Unis, est connue pour ses nombreux monuments et musées nationaux, y compris le Capitole, la Maison Blanche, le Lincoln Memorial et le National Mall. Ne manquez pas de visiter les musées du Smithsonian Institution, dont l'entrée est gratuite. 🏛️🇺🇸"),

                                       Destination(name: "Turin", anecdote: "Turin, en Italie, est connue pour ses élégantes places, ses arcades et ses cafés historiques. C'est aussi là que se trouve le Musée égyptien, qui possède l'une des plus grandes collections d'art égyptien en dehors de l'Égypte. Et n'oubliez pas d'essayer le gianduiotto, un délicieux chocolat local. 🍫🏛️"),

                                       Destination(name: "Milan", anecdote: "Milan est l'un des centres mondiaux de la mode et du design. Elle est également célèbre pour sa cathédrale gothique, le Duomo, et pour l'opéra La Scala. Ne manquez pas de voir La Cène de Léonard de Vinci, mais n'oubliez pas de réserver à l'avance. 🎭🇮🇹"),

                                       Destination(name: "Bergame", anecdote: "Bergame, en Lombardie, est une ville charmante connue pour sa cité haute médiévale, ses rues pavées et ses vues panoramiques. Essayez la polenta taragna, une spécialité locale, et visitez l'Accademia Carrara, un musée d'art impressionnant. 🎨🏰"),
                                       Destination(name: "Atlanta", anecdote: "Atlanta, en Géorgie, est connue pour son rôle important dans la guerre civile et les droits civils aux États-Unis. Visitez le Centre Martin Luther King Jr. pour en savoir plus sur ce leader influent. Atlanta est également le siège de CNN et de Coca-Cola, avec des visites disponibles pour les deux. 📺🥤"),

                                       Destination(name: "Monza", anecdote: "Monza, en Italie, est surtout connue pour son circuit de Formule 1, l'Autodromo Nazionale Monza. La ville abrite également la Villa Reale, un palais néoclassique, et le Parco di Monza, l'un des plus grands parcs clos d'Europe. 🏎️🏞️"),

                                       Destination(name: "Riyad", anecdote: "Riyad, la capitale de l'Arabie Saoudite, est une ville moderne connue pour ses gratte-ciel, dont la tour Kingdom et la tour Al Faisaliah. Le Musée national de l'Arabie Saoudite et la forteresse historique de Masmak sont des sites incontournables pour en savoir plus sur l'histoire du pays. 🏙️🕌"),

                                       Destination(name: "Jeddah", anecdote: "Jeddah est une ville portuaire importante en Arabie Saoudite et est souvent considérée comme la porte d'entrée vers la Mecque. Jeddah est également connue pour la Fontaine du Roi Fahd, la plus haute fontaine d'eau salée au monde. La vieille ville d'Al-Balad, avec ses bâtiments historiques en corail, est un site du patrimoine mondial de l'UNESCO. 🌊🌴"),

                                       Destination(name: "La Mecque", anecdote: "La Mecque est une ville sainte de l'islam, où des millions de musulmans se rendent chaque année pour le hajj, le pèlerinage obligatoire. Le centre de la ville est dominé par la Masjid al-Haram, la plus grande mosquée du monde, qui entoure la Kaaba. Il faut noter que seuls les musulmans sont autorisés à entrer dans la ville. 🕋🙏"),
                                       Destination(name: "La Havane", anecdote: "La Havane, la capitale de Cuba, est célèbre pour son architecture coloniale colorée, ses voitures classiques et sa musique salsa. Promenez-vous dans les rues pavées de la Vieille Havane, dégustez un mojito dans un bar local et dansez toute la nuit au son de la musique cubaine. 🎵🍹"),

                                       Destination(name: "Palavas-les-Flots", anecdote: "Palavas-les-Flots est une station balnéaire populaire sur la côte méditerranéenne de la France. Elle est connue pour ses belles plages, ses sports nautiques et sa délicieuse cuisine de fruits de mer. N'oubliez pas de faire un tour sur le petit train touristique pour une vue panoramique sur la ville et la mer. 🏖️🐚"),

                                       Destination(name: "Monaco", anecdote: "Monaco, le deuxième plus petit État indépendant du monde, est connu pour son casino de Monte-Carlo, son Grand Prix de Formule 1, et comme domicile de la famille royale Grimaldi. Promenez-vous dans les jardins exotiques, visitez le palais princier et admirez les yachts de luxe dans le port. 🏎️💰"),

                                       Destination(name: "Gibraltar", anecdote: "Gibraltar est un territoire britannique d'outre-mer situé à l'extrémité sud de la péninsule ibérique. Il est surtout connu pour le Rocher de Gibraltar, une impressionnante formation calcaire, et pour ses macaques de Barbarie, les seuls singes sauvages d'Europe. Profitez d'une vue panoramique sur l'Atlantique et la Méditerranée depuis le sommet. 🐒🌄"),
                                       Destination(name: "Ibiza", anecdote: "Ibiza, une île espagnole dans la mer Méditerranée, est célèbre pour sa vie nocturne animée et ses clubs de renommée mondiale. Mais il y a plus à Ibiza que la fête, l'île offre de belles plages, une vieille ville charmante classée au patrimoine mondial de l'UNESCO, et une atmosphère relaxante pendant la journée. ☀️🎉"),

                                       Destination(name: "Pise", anecdote: "Pise, en Italie, est surtout connue pour sa tour penchée, qui est en fait le clocher de la cathédrale de la ville. Mais n'oubliez pas de visiter le reste du Campo dei Miracoli, y compris la cathédrale elle-même et le baptistère. Pise est également une ville universitaire animée avec une riche histoire et culture. 🏛️🎓"),

                                       Destination(name: "Jakarta", anecdote: "Jakarta, la capitale de l'Indonésie, est une ville animée et en pleine croissance. Elle est connue pour son mélange de cultures, avec des influences malaises, chinoises, indiennes, arabes et européennes. Visitez le monument national, explorez le quartier historique de Kota Tua et faites du shopping au marché de Tanah Abang. 🌆🇮🇩"),
                                       Destination(name: "Yogyakarta", anecdote: "Yogyakarta, sur l'île de Java en Indonésie, est un centre d'éducation et de culture javanaise. La ville est proche de deux importants sites du patrimoine mondial de l'UNESCO : le temple bouddhiste de Borobudur et le complexe de temples hindous de Prambanan. Yogyakarta est également connue pour son batik traditionnel. 🕌🎨"),
                                       Destination(name: "Lucerne", anecdote: "Lucerne est une ville pittoresque située au cœur de la Suisse. Elle est célèbre pour son pont en bois couvert, le Kapellbrücke, qui est le plus ancien pont en bois d'Europe. Les montagnes environnantes offrent d'excellentes opportunités de randonnée et de ski. 🏞️🎿"),

                                       Destination(name: "Berne", anecdote: "Berne est la capitale de la Suisse et est connue pour sa vieille ville médiévale bien préservée, qui est inscrite au patrimoine mondial de l'UNESCO. La Tour de l'Horloge (Zytglogge) et l'Ours de Berne, un parc à ours situé dans la ville, sont des attractions populaires. 🏰🐻"),

                                       Destination(name: "Lausanne", anecdote: "Lausanne, sur la rive nord du lac Léman, est connue comme la capitale olympique car elle abrite le siège du Comité International Olympique. Visitez le Musée Olympique et profitez de la belle vue sur le lac et les Alpes françaises. 🏅🏞️")

   ]
// Photo des destinations sympa
    let photos: [String] = ["Paris", "Rio", "Londres", "Pyrenées", "Los angeles"]

    @State private var selectedCityAnecdote: String? = nil
    @State private var isCityNotFound = false
    @State private var isInvalidDateRange = false

    var body: some View {
        
        
        GeometryReader { geometry in
            VStack(spacing: 0) {
                ZStack {
                    LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .top, endPoint: .bottom)
                        .frame(height: geometry.size.height * 0.10)
                        .edgesIgnoringSafeArea(.top)

                    Text("Packit 🛄🏕️❄️")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
                        .offset(y: -geometry.size.height * 0.05)
                }
                Spacer()
            }
            .statusBar(hidden: true)

            ScrollView {
                Text("Salut à toi jeune voyageur, ready pour de nouvelles aventures ?")
                    .font(.title)
                    .padding(.top, 16)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                VStack {
                    HStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(Color.red)
                                .frame(width: 40, height: 40)
                            Image(systemName: "airplane")
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                        }
                        ZStack {
                            Circle()
                                .fill(Color.blue)
                                .frame(width: 40, height: 40)
                            Image(systemName: "suitcase")
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                        }
                        ZStack {
                            Circle()
                                .fill(Color.green)
                                .frame(width: 40, height: 40)
                            Image(systemName: "snow")
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                        }
                        ZStack {
                            Circle()
                                .fill(Color.yellow)
                                .frame(width: 40, height: 40)
                            Image(systemName: "sun.max")
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.top)
                    Spacer().frame(height: 30) // Ajoute de l'espace entre le HStack et le TextField
                    TextField("Entre le nom d'une ville, le début de ton aventure", text: $searchCity)
                        .font(.title2)
                        .padding()
                        .background(Color.white) // Ajoute une couleur de fond pour le rendre plus voyant
                        .cornerRadius(10) // Arrondit les coins pour un aspect plus moderne
                        .shadow(radius: 10) // Ajoute une ombre pour un aspect 3D
                        .padding([.horizontal, .bottom]) // Ajoute de l'espace sur les côtés pour que le TextField ne touche pas les bords de l'écran
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onChange(of: searchCity, perform: { _ in
                            weatherData.removeAll()
                            selectedCityAnecdote = getAnecdote(for: searchCity) // Met à jour l'anecdote en fonction de la ville saisie
                            isCityNotFound = false // Réinitialise le statut de la ville introuvable
                        })


                    DatePicker("Date de début", selection: $startDate, displayedComponents: .date)
                        .padding(.horizontal) //donne une date de debut

                    DatePicker("Date de fin", selection: $endDate, displayedComponents: .date)
                        .padding(.horizontal)  // donne une date de fin

                }
                .padding(.vertical, 8)
                .background(Color.white)
                .cornerRadius(8)
                .padding(.horizontal)

                Button(action: {
                    fetchWeatherData(for: searchCity)
                    selectedCityAnecdote = getAnecdote(for: searchCity) // Récupère l'anecdote de la ville saisie
                }) {
                    Text("Rechercher")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .disabled(searchCity.isEmpty)
                .padding()
// condition si la ville existe pas et si les dates ne sont pas entre le current day et le 10eme jour
                if isCityNotFound {
                    Text("Erreur : Ville introuvable")
                        .foregroundColor(.red)
                        .padding(.bottom)
                } else if isInvalidDateRange {
                    Text("Erreur : Plage de dates invalide")
                        .foregroundColor(.red)
                        .padding(.bottom)
                }
// pour l'anecdote
                if let anecdote = selectedCityAnecdote, !searchCity.isEmpty {
                    Text(anecdote)
                        .font(.caption)
                        .padding(.horizontal)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.gray)
                        .padding(.bottom, 4)
                }
// les suggestions pour les baggages
                if !weatherData.isEmpty {
                    VStack {
                        ScrollView(.horizontal) {
                            HStack(spacing: 16) {
                                ForEach(weatherData.keys.sorted(), id: \.self) { key in
                                    if let weatherInfo = weatherData[key] {
                                        VStack {
                                            Text("\(key): \(weatherInfo.roundedTemperature) °C")
                                                .font(.title)
                                                .padding()
                                                .background(Color.blue)
                                                .foregroundColor(.white)
                                                .cornerRadius(8)

                                            weatherInfo.weatherIcon
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 64, height: 64)
                                            Text(weatherInfo.weatherText)
                                                .padding(.bottom)

                                            if let suggestedItems = weatherInfo.suggestedItems {
                                                ForEach(suggestedItems, id: \.self) { item in
                                                    HStack {
                                                        Image(systemName: "circle.fill")
                                                            .foregroundColor(.blue)
                                                            .font(.body)
                                                        Text(item)
                                                            .font(.body)
                                                    }
                                                }
                                                .padding(.horizontal)
                                            }
                                        }
                                        .frame(maxWidth: .infinity)
                                        .background(Color.gray.opacity(0.2))
                                        .cornerRadius(8)
                                        .padding(.horizontal, 16)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(photos, id: \.self) { photo in
                            Image(photo)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 200)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(16)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 16)
            }
            .padding(.top, geometry.safeAreaInsets.top + 16)
        }
    }
// recuperation de l'api weather
    func fetchWeatherData(for city: String) {
        let encodedCity = city.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let urlString = "https://api.weatherapi.com/v1/forecast.json?key=\(apiKey)&q=\(encodedCity)&days=10&aqi=no&alerts=no"

        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }

        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { output -> Data in
                guard let response = output.response as? HTTPURLResponse else {
                    throw URLError(.badServerResponse)
                }

                if response.statusCode == 400 {
                    isCityNotFound = true
                    throw URLError(.badServerResponse)
                }

                guard response.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }

                return output.data
            }
            .decode(type: WeatherResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Error: \(error)")
                case .finished:
                    break
                }
            }, receiveValue: { [self] decodedResponse in
                let forecast = decodedResponse.forecast.forecastday

                let filteredForecast = forecast.filter { forecastDay in
                    let forecastDate = forecastDay.date
                    return isDateInRange(forecastDate)
                }

                weatherData = filteredForecast.reduce(into: [:]) { result, forecastDay in
                    let date = forecastDay.date
                    let weatherText = forecastDay.day.condition.text
                    let iconURL = "https:\(forecastDay.day.condition.icon)"

                    if let temperature = forecastDay.day.avgtemp_c {
                        let suggestedItems = getSuggestedItems(for: weatherText, temperature: temperature)
                        result[date] = WeatherInfo(temperature: temperature, weatherText: weatherText, weatherIconURL: iconURL, suggestedItems: suggestedItems)
                    }
                }
            })
            .store(in: &cancellables)
    }
    func isDateInRange(_ date: String) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let startDate = dateFormatter.date(from: dateFormatter.string(from: startDate)),
              let endDate = dateFormatter.date(from: dateFormatter.string(from: endDate)) else {
            return false
        }

        let forecastDate = dateFormatter.date(from: date)
        return forecastDate?.isBetween(startDate, and: endDate) ?? false
    }
// conditions pour les baggages, peut etre stocker dans une fonction
    func getSuggestedItems(for weatherText: String, temperature: Double) -> [String] {
            var suggestedItems: [String] = []

            let temperatureDescription: String
            if temperature >= 30 {
                temperatureDescription = "chaud"
            } else if temperature >= 20 {
                temperatureDescription = "tiède"
            } else if temperature >= 10 {
                temperatureDescription = "frais"
            } else {
                temperatureDescription = "froid"
            }

            switch weatherText.lowercased() {
            case let text where text.contains("rain"):
                suggestedItems.append(contentsOf: ["Parapluie 🌂", "Imperméable multicolore 🧥", "Bottes de pluie à motifs 👢", "Canard en plastique 🦆"])
                if temperatureDescription == "froid" || temperatureDescription == "frais" {
                    suggestedItems.append("Manteau imperméable avec votre héros de bande dessinée préféré 🦸")
                } else {
                    suggestedItems.append("Manteau imperméable léger qui brille dans le noir 🌃")
                }
            case let text where text.contains("cloud"):
                suggestedItems.append("Casquette avec hélice , ou alors avec du style 🧢")
                if temperatureDescription != "chaud" {
                    suggestedItems.append("Veste légère avec des écussons amusants 👕")
                }
            case let text where text.contains("sun"):
                suggestedItems.append(contentsOf: ["Lunettes de soleil en forme de cœur 🕶️", "Crème solaire parfumée à la noix de coco 🥥", "Chapeau à large bord avec des fleurs 🌸", "Eventail qui fait du bruit de vent 🌬️", "Parasol miniature 🏖️", "petit livre sympa de la destination 📚"])
                if temperatureDescription == "chaud" {
                    suggestedItems.append("Sandales avec des clochettes 🔔")
                }
            case let text where text.contains("snow"):
                suggestedItems.append(contentsOf: ["Manteau d'hiver avec oreilles d'ours 🐻", "Gants qui ressemblent à des pattes d'animaux 🐾", "Bonnet chaud avec une fausse mohawk 👲", "Écharpe extrêmement longue 🧣", "Bottes de neige avec des lumières clignotantes 👢", "Luge 🛷"])
            default:
                break
            }

            switch temperatureDescription {
            case "chaud":
                if !suggestedItems.contains("Manteau imperméable léger qui brille dans le noir 🌃") {
                    suggestedItems.append(contentsOf: ["Maillot de bain avec des palmiers 🌴", "Chemise légère avec des flamants roses 👚", "Shorts à fleurs 🌼", "Sandales qui laissent une empreinte amusante dans le sable 👣", "Serviette de plage avec votre personnage de dessin animé préféré 🧺", "Pistolet à eau 💦", "Matelas gonflable en forme de pizza 🍕"])
                } else {
                    suggestedItems.append(contentsOf: ["Pantalon imperméable qui change de couleur sous la pluie (ou stylé)🌈", "Bottes de pluie qui font du bruit à chaque pas 🔊"])
                }
            case "tiède":
                if !suggestedItems.contains("Manteau imperméable léger qui brille dans le noir eheh 🌃") {
                    suggestedItems.append(contentsOf: ["Chemise à manches courtes avec des cactus 🌵", "Shorts de couleur vive 🩳", "Sandales confortables avec des licornes 🦄", "Chapeau de paille avec une bande dessinée amusante 🎩", "Gourde avec des pailles de couleur 🥤", "Lunettes de soleil en forme de fruits 🍓", "Appareil photo ou ton telephone pour le flex 📱"])
                } else {
                    suggestedItems.append(contentsOf: ["Pantalon imperméable qui change de couleur sous la pluie 🌈", "Bottes de pluie qui font du bruit à chaque pas 🔊"])
                }
            case "frais":
                suggestedItems.append(contentsOf: ["Pantalon long avec des dessins de vaisseaux spatiaux 🚀", "Chemise à manches longues qui brillent dans le noir 🌟", "Chaussures confortables avec des dessins de super-héros 👟", "Bonnet avec des antennes d'alien 👽", "Écharpe à rayures multicolores 🌈", "Gants qui semblent avoir des griffes 🦖"])
            case "froid":
                suggestedItems.append(contentsOf: ["Sous-vêtements thermiques avec des ours polaires 🐻", "Pull chaud avec votre personnage de dessin animé préféré 🐼", "Manteau chaud qui ressemble à un animal en peluche 🦁", "Bottes chaudes avec des semelles lumineuses 💡", "Bâtonnets lumineux pour jouer dans la neige 🎇", "Bouillotte en forme d'animal mignon 🐧"])
            default:
                break
            }
        

            return suggestedItems
        }
    // si il y a pas d'anecdote donné
    func getAnecdote(for cityName: String) -> String {
        if let destination = destinations.first(where: { $0.name.lowercased() == cityName.lowercased() }) {
            return destination.anecdote
        } else {
            return "Aucune anecdote disponible."
        }
    }
}
// representation des donnee meteo grace a l'api
extension Date {
    func isBetween(_ date1: Date, and date2: Date) -> Bool {
        return (min(date1, date2) ... max(date1, date2)).contains(self)
    }
}

struct WeatherResponse: Codable {
    let forecast: Forecast
}

struct Forecast: Codable {
    let forecastday: [ForecastDay]
}

struct ForecastDay: Codable {
    let date: String
    let day: DayData
}

struct DayData: Codable {
    let avgtemp_c: Double?
    let condition: WeatherCondition
}

struct WeatherCondition: Codable {
    let text: String
    let icon: String
}

struct WeatherInfo {
    let temperature: Double
    let weatherText: String
    let weatherIconURL: String
    let suggestedItems: [String]?

    var roundedTemperature: Int {
        return Int(temperature.rounded())
    }

    var weatherIcon: Image {
        if let url = URL(string: weatherIconURL), let data = try? Data(contentsOf: url), let uiImage = UIImage(data: data) {
            return Image(uiImage: uiImage)
                .resizable()
        } else {
            return Image(systemName: "questionmark")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
