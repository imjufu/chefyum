# ChefYum

Chez ChefYum, on simplifie la vie des gens en les aidant à planifier des repas sains et adaptés à leurs contraintes alimentaires, semaine après semaine.

Allergies, intolérances, régimes végétariens ou simplement envie de mieux manger ? Notre plateforme propose des menus personnalisés, faciles à préparer, avec des recettes équilibrées, une liste de courses automatique et des conseils pratiques pour gagner du temps.

Notre objectif : rendre l’alimentation saine accessible, simple et agréable pour toutes les personnes, même les plus occupées.

ChefYum, c’est le bon repas, pour les bonnes personnes, au bon moment.

![Capture d'écran de la page d'accueil de l'application.](/preview.png)

## Environnement de développement

### Prérequis

* api
  * docker (28.0)
  * docker-compose (2.34)
  * ruby (3.3)
* app
  * node (22.13)

### Installation

```bash
git clone git@github.com:imjufu/chefyum.git

# api
cd chefyum/api
docker-compose up -d
bundle install
bundle exec rails db:setup

# app
cd chefyum/app
npm install
```

### Démarrer l'environnement

```bash
# api
cd chefyum/api
bundle exec rails s

# app
cd chefyum/app
npm run dev
```

Par défaut, l'application est accessible à l'adresse : http://localhost:8080/ et l'api est accessible à l'adresse : http://127.0.0.1:3000/

## Qualité logicielle

### Tests unitaires et fonctionnels

```bash
cd chefyum/api
bundle exec rspec
```

### Code style

```bash
# api
cd chefyum/api
bundle exec rubocop -A

# app
cd chefyum/app
npm run lint
```
