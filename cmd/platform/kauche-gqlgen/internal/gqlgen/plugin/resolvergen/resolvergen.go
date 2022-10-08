package resolvergen

import (
	_ "embed"
	"path/filepath"
	"strings"

	"github.com/99designs/gqlgen/codegen"
	"github.com/99designs/gqlgen/codegen/templates"
	"github.com/99designs/gqlgen/plugin"
)

//go:embed resolver.gotpl
var resolverTemplate string

func New() plugin.Plugin {
	return &Plugin{}
}

type Plugin struct{}

var _ plugin.CodeGenerator = &Plugin{}

func (m *Plugin) Name() string {
	return "resolvergen"
}

func (m *Plugin) GenerateCode(data *codegen.Data) error {
	if !data.Config.Resolver.IsDefined() {
		return nil
	}

	return m.generateSingleFile(data)
}

func (m *Plugin) generateSingleFile(data *codegen.Data) error {
	file := File{}

	for _, o := range data.Objects {
		if o.HasResolvers() {
			file.Objects = append(file.Objects, o)
		}
		for _, f := range o.Fields {
			if !f.IsResolver {
				continue
			}

			resolver := Resolver{
				Object:         o,
				Field:          f,
				Comment:        "// foohoge",
				Implementation: `panic("not implemented!!")`,
			}
			file.Resolvers = append(file.Resolvers, &resolver)
		}
	}

	resolverBuild := &ResolverBuild{
		File:         &file,
		PackageName:  data.Config.Resolver.Package,
		ResolverType: data.Config.Resolver.Type,
		HasRoot:      true,
	}

	return templates.Render(templates.Options{
		GeneratedHeader: true,
		PackageName:     data.Config.Resolver.Package,
		Filename:        data.Config.Resolver.Filename,
		Data:            resolverBuild,
		Packages:        data.Config.Packages,
		Template:        resolverTemplate,
	})
}

type ResolverBuild struct {
	*File
	HasRoot      bool
	PackageName  string
	ResolverType string
}

type File struct {
	// These are separated because the type definition of the resolver object may live in a different file from the
	// resolver method implementations, for example when extending a type in a different graphql schema file
	Objects         []*codegen.Object
	Resolvers       []*Resolver
	imports         []Import
	RemainingSource string
}

func (f *File) Imports() string {
	for _, imp := range f.imports {
		if imp.Alias == "" {
			_, _ = templates.CurrentImports.Reserve(imp.ImportPath)
		} else {
			_, _ = templates.CurrentImports.Reserve(imp.ImportPath, imp.Alias)
		}
	}
	return ""
}

type Resolver struct {
	Object         *codegen.Object
	Field          *codegen.Field
	Comment        string
	Implementation string
}

func gqlToResolverName(base string, gqlname, filenameTmpl string) string {
	gqlname = filepath.Base(gqlname)
	ext := filepath.Ext(gqlname)
	if filenameTmpl == "" {
		filenameTmpl = "{name}.resolvers.go"
	}
	filename := strings.ReplaceAll(filenameTmpl, "{name}", strings.TrimSuffix(gqlname, ext))
	return filepath.Join(base, filename)
}

type Import struct {
	Alias      string
	ImportPath string
}
