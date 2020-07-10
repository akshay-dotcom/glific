defmodule GlificWeb.Flows.FlowEditorController do
  @moduledoc """
  The Flow Editor Controller
  """

  use GlificWeb, :controller

  alias Glific.Flows


  @doc false
  def globals(conn, _params) do
    conn
    |> json(%{results: []})
  end

  def groups(conn, _params) do
    conn
    |> json(%{results: []})
  end

  def groups_post(conn, params) do
    conn
    |> json(%{
      uuid: generate_uuid(),
      query: nil,
      status: "ready",
      count: 0,
      name: params["name"]
    })
  end

  def fields(conn, _params) do
    conn
    |> json(%{results: []})
  end

  @spec fields_post(Plug.Conn.t(), nil | maybe_improper_list | map) :: Plug.Conn.t()
  def fields_post(conn, params) do
    conn
    |> json(%{
      key: Slug.slugify(params["label"], separator: "_"),
      name: params["label"],
      value_type: "text"
    })
  end

  @spec labels(Plug.Conn.t(), nil | maybe_improper_list | map) :: Plug.Conn.t()
  def labels(conn, _params) do
    conn
    |> json(%{results: []})
  end

  @spec labels_post(Plug.Conn.t(), nil | maybe_improper_list | map) :: Plug.Conn.t()
  def labels_post(conn, params) do
    conn
    |> json(%{
      uuid: generate_uuid(),
      name: params["name"],
      count: 0
    })
  end

  @spec channels(Plug.Conn.t(), nil | maybe_improper_list | map) :: Plug.Conn.t()
  def channels(conn, _params) do
    channels = %{
      results: [
        %{
          uuid: generate_uuid(),
          name: "WhatsApp",
          address: "+18005234545",
          schemes: ["whatsapp"],
          roles: ["send", "receive"]
        }
      ]
    }

    json(conn, channels)
  end

  @spec classifiers(Plug.Conn.t(), nil | maybe_improper_list | map) :: Plug.Conn.t()
  def classifiers(conn, _params) do
    classifiers = %{
      results: [
        %{
          uuid: generate_uuid(),
          name: "Travel Agency",
          type: "wit",
          intents: ["book flight", "rent car"],
          created_on: "2019-10-15T20:07:58.529130Z"
        }
      ]
    }

    json(conn, classifiers)
  end

  @spec ticketers(Plug.Conn.t(), nil | maybe_improper_list | map) :: Plug.Conn.t()
  def ticketers(conn, _params) do
    ticketers = %{
      results: [
        %{
          uuid: generate_uuid(),
          name: "Email",
          type: "mailgun",
          created_on: "2019-10-15T20:07:58.529130Z"
        }
      ]
    }

    json(conn, ticketers)
  end


  @spec resthooks(Plug.Conn.t(), nil | maybe_improper_list | map) :: Plug.Conn.t()
  def resthooks(conn, _params) do
    resthooks = %{
      results: [
        %{resthook: "my-first-zap", subscribers: []},
        %{resthook: "my-other-zap", subscribers: []}
      ]
    }

    json(conn, resthooks)
  end

  @spec templates(Plug.Conn.t(), nil | maybe_improper_list | map) :: Plug.Conn.t()
  def templates(conn, _params) do
    templates = %{
      results: [
        %{
          uuid: generate_uuid(),
          name: "sample_template",
          created_on: "2019-04-02T22:14:31.549213Z",
          modified_on: "2019-04-02T22:14:31.569739Z",
          translations: [
            %{
              language: "eng",
              content: "Hi {{1}}, are you still experiencing problems with {{2}}?",
              variable_count: 2,
              status: "approved",
              channel: %{
                uuid: "0f661e8b-ea9d-4bd3-9953-d368340acf91",
                name: "WhatsApp"
              }
            },
            %{
              language: "fra",
              content: "Bonjour {{1}}, a tu des problems avec {{2}}?",
              variable_count: 2,
              status: "pending",
              channel: %{
                uuid: "0f661e8b-ea9d-4bd3-9953-d368340acf91",
                name: "WhatsApp"
              }
            }
          ]
        }
      ]
    }

    json(conn, templates)
  end

  @spec languages(Plug.Conn.t(), nil | maybe_improper_list | map) :: Plug.Conn.t()
  def languages(conn, _params) do
    languages = %{
      results: [
        %{
          iso: "eng",
          name: "English"
        },
        %{
          iso: "Hi",
          name: "Hindi"
        }
      ]
    }

    json(conn, languages)
  end

  @spec environment(Plug.Conn.t(), nil | maybe_improper_list | map) :: Plug.Conn.t()
  def environment(conn, _params) do
    environment = %{
      date_format: "YYYY-MM-DD",
      time_format: "hh:mm",
      timezone: "Africa/Kigali",
      languages: ["eng", "spa", "fra"]
    }

    json(conn, environment)
  end

  @spec recipients(Plug.Conn.t(), nil | maybe_improper_list | map) :: Plug.Conn.t()
  def recipients(conn, _params) do
    recipients = %{
      results: [
        %{
          name: "Cat Fanciers",
          id: "eae05fb1-3021-4df2-a443-db8356b953fa",
          type: "group",
          extra: 212
        },
        %{
          name: "Anne",
          id: "673fa0f6-dffd-4e7d-bcc1-e5709374354f",
          type: "contact"
        }
      ]
    }

    json(conn, recipients)
  end

  @spec completion(Plug.Conn.t(), nil | maybe_improper_list | map) :: Plug.Conn.t()
  def completion(conn, _params) do
    json(conn, %{})
  end

  @spec activity(Plug.Conn.t(), nil | maybe_improper_list | map) :: Plug.Conn.t()
  def activity(conn, _params) do
    activity = %{
      nodes: %{},
      segments: %{}
    }

    json(conn, activity)
  end

  @spec flows(Plug.Conn.t(), nil | maybe_improper_list | map) :: Plug.Conn.t()
  def flows(conn, %{"vars" => vars}) do
    results =
      case vars do
        [] ->
          [
            %{
              uuid: "9ecc8e84-6b83-442b-a04a-8094d5de997b",
              name: "Customer Service",
              type: "message",
              archived: false,
              labels: [],
              parent_refs: ["order_number", "customer_id"],
              expires: 10080
            }
          ]

        [_uuid] ->
          %{
            name: "Customer Service",
            type: "message",
            uuid: "9ecc8e84-6b83-442b-a04a-8094d5de997b",
            nodes: []
          }
      end

    json(conn, results)
  end

  @spec revisions(Plug.Conn.t(), nil | maybe_improper_list | map) :: Plug.Conn.t()
  def revisions(conn, %{"vars" => vars}) do
    case vars do
      [flow_uuid] -> json(conn, Flows.get_flow_revision_list(flow_uuid))
      [flow_uuid, revison_number] -> json(conn, Flows.get_flow_revision(flow_uuid, revison_number))
    end
  end

  @spec save_revisions(Plug.Conn.t(), nil | maybe_improper_list | map) :: Plug.Conn.t()
  def save_revisions(conn, params) do

    user = %{email: "chancerton@nyaruka.com", name: "Chancellor von Frankenbean"}
    asset = %{user: user, created_on: "2020-07-08T19:18:43.253Z", id: 1, version: "13.0.0", revision: 1}
    Flows.create_flow_revision(params)

    json(conn, asset)
  end

  def functions(conn, _) do
    functions = File.read!("assets/flows/functions.json")
    |> Jason.decode!()

    json(conn, functions)

  end

  defp generate_uuid() do
    Faker.UUID.v4()
  end
end
