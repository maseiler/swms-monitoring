<div id="top"></div>
<!--
*** Thanks for checking out the Best-README-Template. If you have a suggestion
*** that would make this better, please fork the repo and create a pull request
*** or simply open an issue with the tag "enhancement".
*** Don't forget to give the project a star!
*** Thanks again! Now go create something AMAZING! :D
-->

<br />
<div align="center">
  <a href="https://github.com/maseiler/swms-monitoring">
    <img src="images/logo.png" alt="Logo" width="300" height="300">
  </a>

  <h3 align="center">Extended Metrics Project for Apache Airflow</h3>

  <p align="center">
    Gain more insight in your scientific workflow management system and optimize your workflow execution while minimizing your costs.
    <br />
    <a href="https://github.com/maseiler/swms-monitoring"><strong>Explore the docs (coming soon) »</strong></a>
    <br />
    <br />
    <a href="https://github.com/maseiler/swms-monitoring">View Demo (coming Soon)</a>
    
  </p>
</div>



<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#usage">Usage (coming soon)</a></li>
    <li><a href="#roadmap">Roadmap</a></li>
    <li><a href="#license">License (todo)</a></li>
  </ol>
</details>



<!-- ABOUT THE PROJECT -->
## About The Project

[![Product Name Screen Shot][product-screenshot]](https://github.com/maseiler/swms-monitoring)

This is a repository for the university project "Master Project: Distributed Systems - Monitoring of Scientific Workflows" attended during the summer term 2022 at the Technical University Berlin. In this project we should gain practical experience with so called Scientific Workflow Management Systems (SWMS) and extend existing ones with additional functionalities to give them extra value. In our subproject we extend the SWMS Apache Airflow monitoring capabilities with the following capabilities:

* coming soon

The project should use a semi realistic environment and is therefore settled in the [kubernetes](https://kubernetes.io/de/) ecosystem to reflect the actual real world scenarios with huge workloads in highly distributed systems.  

<p align="right">(<a href="#top">back to top</a>)</p>



<!-- GETTING STARTED -->
## Getting Started

We try to make the deployment as simple as possible and therefore using kubernetes and helm to deploy a working prototype to the Google Cloud Plattform.

To get a copy up and running follow these simple example steps.

### Prerequisites
- Install [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/)
- Install [Helm](https://helm.sh/docs/intro/install/)
- Install and configure [gcloud CLI](https://cloud.google.com/sdk/gcloud/)

### Deploy

Simply run `./setup.sh` in the cloned repository directory.


### Deprovision
> IMPORTANT: Always shut down all instances when you are done working!
> 
Run `./deprovision.sh` to prune all artificats and confirm with `y`.


<p align="right">(<a href="#top">back to top</a>)</p>






<!-- USAGE EXAMPLES -->
## Usage (coming soon)

Use this space to show useful examples of how a project can be used. Additional screenshots, code examples and demos work well in this space. You may also link to more resources.

_For more examples, please refer to the [Documentation](https://example.com)_

<p align="right">(<a href="#top">back to top</a>)</p>



<!-- ROADMAP -->
## Roadmap
See the [open issues](https://github.com/maseiler/swms-monitoring/issues) for a full list of proposed features (and known issues).

Also have a look at our [project page](https://github.com/maseiler/swms-monitoring/projects/1) for a clearer structure of the issues and overview which issues are worked on. 

<p align="right">(<a href="#top">back to top</a>)</p>


<!-- LICENSE -->
## License (TODO)

Distributed under the MIT License. See `LICENSE.txt` for more information.

<p align="right">(<a href="#top">back to top</a>)</p>

[product-screenshot]: images/placeholder_demo.png

