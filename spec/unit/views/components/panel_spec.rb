require 'spec_helper'

describe ActiveAdmin::Views::Panel do
  let(:arbre_panel) do
    render_arbre_component do
      panel "My Title", icon: :arrow_down do
        header_action link_to("My Link", "https://www.github.com/gregbell/active_admin")
        span("Hello World")
      end
    end
  end

  let(:panel_html) { Capybara.string(arbre_panel.to_s) }

  it "should have a title h3" do
    expect(panel_html).to have_css 'h3', content: "My Title"
  end

  it "should add panel actions to the panel header" do
    expect(panel_html).to have_css 'h3 > div.header_action a', content: 'My Link', href: "https://www.github.com/gregbell/active_admin"
  end

  it "should have a contents div" do
    expect(panel_html).to have_css 'div.panel_contents'
  end

  it "should add children to the contents div" do
    expect(panel_html).to have_css 'div.panel_contents > span', content: "Hello World"
  end

  it "should set the icon" do
    expect(panel_html).to have_css "h3 > span.icon"
  end

  context "with html-safe title" do
    let(:arbre_panel) do
      title_with_html = %q[Title with <abbr>HTML</abbr>].html_safe
      render_arbre_component do
        panel(title_with_html)
      end
    end

    it "should allow a html_safe title" do
      expect(panel_html).to have_css "h3", content: "Title with HTML"
      expect(panel_html).to have_css "h3 > abbr", content: "HTML"
    end
  end

  describe "#children?" do
    let(:arbre_panel) do
      render_arbre_component do
        panel("A Panel")
      end
    end

    it "returns false if no children have been added to the panel" do
      expect(arbre_panel.children?).to eq false
    end
  end
end
