# Cloudflare DNS Update Script

This script helps you automatically update DNS records in Cloudflare when your public IP address changes. It's especially useful if you're using a dynamic IP address and want to ensure that subdomains on your domain always point to the current public IP.

You can also choose to enable or disable Cloudflare's proxy for the DNS records.

## Prerequisites

- **Cloudflare API Token**: You need an API token with the appropriate permissions to edit DNS records.
- **jq**: A command-line tool for processing JSON data, used in the script to handle Cloudflare API responses.
- **cURL**: Required to send HTTP requests to the Cloudflare API.
- A Linux server or any Unix-like system.

## Setup

1. **Create a Cloudflare API Token**

    Go to the [Cloudflare Dashboard](https://dash.cloudflare.com/) and create an API token with the following permissions:
    - **Zone.Zone**
    - **Zone.DNS**

2. **Download the Script**

    Clone this repository or download the `update-dns.sh` script.

3. **Insert API Token and Zone ID**

    - Open the `update-dns.sh` file and replace the following placeholders:
      - `your_zone_id`: Your Cloudflare zone ID, which you can find in the Cloudflare dashboard.
      - `your_api_token`: Your Cloudflare API token.
      - `yourdomain.com`: Your domain (e.g., `example.com`).

4. **Install Dependencies**

    Make sure that `curl` and `jq` are installed on your system:

    - To install `jq`:
      ```bash
      sudo apt-get install jq      # Debian/Ubuntu
      sudo yum install jq          # CentOS/RHEL
      ```

    - To install `curl`:
      ```bash
      sudo apt-get install curl    # Debian/Ubuntu
      sudo yum install curl        # CentOS/RHEL
      ```

## Proxy Option

The script includes an option to enable or disable Cloudflare's proxy for your DNS records. By default, the proxy is disabled (`proxied: false`). To enable the proxy, simply pass `true` as the first argument when running the script:

### Usage

1. **Without Proxy (default)**:
    ```bash
    ./update-dns.sh
    ```

2. **With Proxy Enabled**:
    ```bash
    ./update-dns.sh true
    ```

## Cron Job Setup

To run the script periodically, you can set up a cron job. For example, to run the script every 5 minutes:

1. Open the crontab configuration:

    ```bash
    crontab -e
    ```

2. Add the following cron job:

    ```bash
    */5 * * * * /path/to/your/script.sh >> /var/log/my_cronjob.log 2>&1
    ```

    - This will run the script every 5 minutes.
    - The output will be written to the log file `/var/log/my_cronjob.log`.

## Troubleshooting

- **Cron job isn't running**: Check that `curl` and `jq` are correctly installed and verify that the script works manually.
- **API errors**: Make sure your API token is correct and has the necessary permissions.
- **No output in the log**: Check the cron logs using `grep CRON /var/log/syslog` (Debian/Ubuntu) or `cat /var/log/cron` (CentOS/RHEL).

## License

This project is licensed under the MIT License.

