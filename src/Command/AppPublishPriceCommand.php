<?php

namespace App\Command;

use Symfony\Component\Console\Attribute\AsCommand;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputArgument;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Input\InputOption;
use Symfony\Component\Console\Output\OutputInterface;
use Symfony\Component\Console\Style\SymfonyStyle;
use Symfony\Component\Mercure\HubInterface;
use Symfony\Component\Mercure\Update;

#[AsCommand(
    name: 'app:publish-price',
    description: 'Envoie des prix en temps réel via Mercure',
)]
class AppPublishPriceCommand extends Command
{
    // On déclare le service ici
    public function __construct(
        private HubInterface $hub
    ) {
        parent::__construct();
    }

    protected function execute(InputInterface $input, OutputInterface $output): int
    {
        $output->writeln('Démarrage de la simulation...');

        while (true) {
            $newPrice = rand(44000, 46000);
            
            // On crée le message Turbo Stream
$update = new Update(
    'btc-data', // Utilise un nom simple comme 'btc-data'
    sprintf('<turbo-stream action="replace" target="btc-price"><template>%d</template></turbo-stream>', $newPrice)
);

            // C'est ici qu'on utilise $this->hub injecté plus haut
            $this->hub->publish($update);

            $output->writeln("Prix envoyé : $newPrice");
            
            sleep(2); // On attend 2 secondes avant le prochain envoi
        }

        return Command::SUCCESS;
    }
}
