<?php

namespace App\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;

class DashboardController extends AbstractController
{
    #[Route('/dashboard', name: 'app_dashboard')]
    public function index(): Response
    {
        // Get Mercure Public URL from environment
        $mercurePublicUrl = $_ENV['MERCURE_PUBLIC_URL'] ?? 'http://localhost:56427/.well-known/mercure';
        
        return $this->render('dashboard/index.html.twig', [
            'initial_price' => 45000, // Prix de départ fictif
            'mercure_public_url' => $mercurePublicUrl,
        ]);
    }
}