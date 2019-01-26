# Building slides
Ensure you have valid credentials for md2gslides in `$HOME/.credentials`
Set the HashiCorp template ID to the environment variable `DEFAULT_TEMPLATE`

The build process will run the md2gslides utility in a Docker container and write the slides to the Google Slides.

Note: Any images embedded into the slides need to be accessible via HTTP, upload images to the `images` folder for your deck, commit to GitHub and reference them using a raw.githubusercontent.com url.  E.g:

```
![](https://raw.githubusercontent.com/hashicorp/service-mesh-training/master/slides/security/images/bypass.png){pad=100 offset-y=100}
```

## Building Security module slides/security/security.md

```bash
$ make build_security
Building security deck
View your presentation at: https://docs.google.com/presentation/d/1mvQLdG7JELRngzt8LmcK8n6NT7zB6yQvRWl6mks2ZRQ
```
