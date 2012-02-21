import com.hp.hpl.jena.rdf.model.*
import com.hp.hpl.jena.tdb.*

// Configuration values
// args[0] : Location of data
def storesDirectory = '/usr/local/trustlab-apps/visko-3.0-triple-store/triple-store/'
def modelName = 'TDB-VISKO-3'

def modelDirectoryName = storesDirectory + modelName
def modelDirectory = new File(modelDirectoryName)

// If it exists then clean it, else create it.
if ( modelDirectory.exists() ) modelDirectory.listFiles().each { it.delete() }
else modelDirectory.mkdir()

Model model = TDBFactory.createModel(modelDirectoryName)

// Iterate through all files and load any pml data found
new File(args[0]).eachFileRecurse {
	try {
		if ( it.isFile() && it.canRead() && it.text.contains("http://www.w3.org/1999/02/22-rdf-syntax-ns#") ) {
			model.read( new FileInputStream(it), null )
		}
	} catch ( Exception e ) { println "Error loading file $it: ${e.toString()}" }
}


println "${modelName} now has ${model.size()} statements."
model.close()

println 'Done.'
