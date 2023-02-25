/* apply infrastructure and check -
 * if dns url returns 200
 *
 * go mod tidy
 * go test -v
 */

package test

import (
	"log"
	"net/http"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestInfrastructure(t *testing.T) {
	// Construct the terraform options with default retryable errors to handle
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		// Set the path to the Terraform code that will be tested.
		TerraformDir: "../Terraform",
		Vars: map[string]interface{}{
			"aws_region":             "ap-south-1",
			"bucket_name":            "da-boring-website-dev",
			"cloudfront_cdn":         "cdn-dev",
			"cloudfront_price_class": "PriceClass_All",
		},
		BackendConfig: map[string]interface{}{
			"bucket": "test-states-min",
			"key":    "boring/test/boring.tfstate",
			"region": "ap-south-1",
		},
	})

	// Clean up resources at the end of the test.
	defer terraform.Destroy(t, terraformOptions)

	// init
	terraform.Init(t, terraformOptions)

	// apply
	terraform.Apply(t, terraformOptions)

	cdn_url := terraform.Output(t, terraformOptions, "cdn_url")
	log.Println(cdn_url)
	assert.Equal(t, "OK", pingUrl(cdn_url))

}

func pingUrl(url) string {
	// ping in the cdn url
	resp, err := http.Get(url)
	if err != nil {
		log.Fatalln(err)
	}
	log.Println(resp.StatusText())
	return resp.StatusText()
}
