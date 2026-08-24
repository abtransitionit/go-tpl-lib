[Top]: #

[governance]: https://github.com/abtransitionit/doc/blob/main/governance/goprj/doc.common.md#governance
[CI]:         https://github.com/abtransitionit/doc/blob/main/governance/goprj/doc.common.md#continuous-integration


<h1 align="center">go-tpl-lib</h1>

[![Main CI](https://github.com/abtransitionit/go-tpl-lib/actions/workflows/ci.yaml/badge.svg?branch=main)](https://github.com/abtransitionit/go-tpl-lib/actions/workflows/ci.yaml)
[![LICENSE](https://img.shields.io/badge/license-Apache_2.0-blue.svg)](https://choosealicense.com/licenses/apache-2.0/)

----

# [↑][Top] Definition

This Git repository defines a standardized template when developing a GO modules made of library packages within the organization.  

This GO modules shares a common [governance] model, code of conduct, contributing guides and [CI].

----

# [↑][Top] Getting Started  


**On github**: Create the GitHub repository
```sh
# define var
lPRJ_NAME="my_prj"
lBRANCH="main"

# tool rely on GITHUB cli
gh repo create "$lPRJ_NAME" --private --source=. --remote=origin --push
```
**Locally**: launch the script that initiate a prj from the template
```sh
#  initialize a prj from the template
curl -fsSL https://raw.githubusercontent.com/abtransitionit/go-tpl-lib/${lBRANCH}/bin/init.sh | sh -s ${lPRJ_NAME}

# bypass cache in dev mode
curl -fsSL -H "Cache-Control: no-cache"  -H "Pragma: no-cache" https://raw.githubusercontent.com/abtransitionit/go-tpl-lib/${lBRANCH}/bin/init.sh | sh -s ${lPRJ_NAME}
```

# [↑][Top] Best practice



**managing errors**
```go
// generic
fmt.Errorf("<operation> <resource>: %w", err)

// example
fmt.Errorf("reading file %q: %w", path, err)
fmt.Errorf("parsing yaml %q: %w", path, err)
fmt.Errorf("opening database %q: %w", dsn, err)
```


---

# [↑][Top] Packages documentation

|name|doc|test|description
|-|-|-|-|
|core|[Doc](#)|[Test](#)|Todo


