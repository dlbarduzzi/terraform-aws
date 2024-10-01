package demo

import "errors"

type Config struct {
	Port int
}

func (c *Config) parseConfig() (*Config, error) {
	if c.Port < 1 {
		return nil, errors.New("env variable DEMO_APP_PORT is missing or invalid")
	}
	return c, nil
}
