require 'rails_helper'

RSpec.describe Ciqual::XmlParser do
  let(:subject) { Ciqual::XmlParser.new(Rails.root.join('spec/fixtures/lite_ciqual_data')) }

  describe '#parse!' do
    it 'returns true' do
      expect(subject.parse!).to be true
    end

    it 'parses food groups' do
      expect { subject.parse! }.to change { subject.food_groups.length }.from(0).to(85)
    end

    it 'parses foods' do
      expect { subject.parse! }.to change { subject.foods.length }.from(0).to(3185)
    end

    it 'sets food groups' do
      subject.parse!
      expect(subject.food_groups.first).to eq([ "010301", { code: "010301", label: "plats de viande sans garniture" } ])
    end

    it 'sets foods' do
      subject.parse!
      expect(subject.foods.first).to eq([
        "1000",
        {
          code: "1000",
          food_group_code: "060303",
          label: "Pastis",
          nutrition_facts: [
            { code: "327", label: "Energie, Règlement UE N° 1169/2011 (kJ/100 g)", value: "1140" },
            { code: "328", label: "Energie, Règlement UE N° 1169/2011 (kcal/100 g)", value: "274" },
            { code: "332", label: "Energie, N x facteur Jones, avec fibres  (kJ/100 g)", value: "1140" },
            { code: "333", label: "Energie, N x facteur Jones, avec fibres  (kcal/100 g)", value: "274" },
            { code: "400", label: "Eau (g/100 g)", value: "59,7" },
            { code: "10000", label: "Cendres (g/100 g)", value: "0,002" },
            { code: "10004", label: "Sel chlorure de sodium (g/100 g)", value: "0" },
            { code: "10110", label: "Sodium (mg/100 g)", value: "0" },
            { code: "10120", label: "Magnésium (mg/100 g)", value: "0" },
            { code: "10150", label: "Phosphore (mg/100 g)", value: "-" },
            { code: "10170", label: "Chlorure (mg/100 g)", value: "-" },
            { code: "10190", label: "Potassium (mg/100 g)", value: "2" },
            { code: "10200", label: "Calcium (mg/100 g)", value: "0" },
            { code: "10251", label: "Manganèse (mg/100 g)", value: "0" },
            { code: "10260", label: "Fer (mg/100 g)", value: "-" },
            { code: "10290", label: "Cuivre (mg/100 g)", value: "-" },
            { code: "10300", label: "Zinc (mg/100 g)", value: "0,02" },
            { code: "10340", label: "Sélénium (µg/100 g)", value: "0" },
            { code: "10530", label: "Iode (µg/100 g)", value: "1" },
            { code: "25000", label: "Protéines, N x facteur de Jones (g/100 g)", value: "0" },
            { code: "25003", label: "Protéines, N x 6.25 (g/100 g)", value: "0" },
            { code: "31000", label: "Glucides (g/100 g)", value: "2,86" },
            { code: "32000", label: "Sucres (g/100 g)", value: "0" },
            { code: "32210", label: "Fructose (g/100 g)", value: "-" },
            { code: "32220", label: "Galactose (g/100 g)", value: "-" },
            { code: "32250", label: "Glucose (g/100 g)", value: "-" },
            { code: "32410", label: "Lactose (g/100 g)", value: "-" },
            { code: "32430", label: "Maltose (g/100 g)", value: "-" },
            { code: "32480", label: "Saccharose (g/100 g)", value: "-" },
            { code: "33110", label: "Amidon (g/100 g)", value: "0" },
            { code: "34000", label: "Polyols totaux (g/100 g)", value: "0" },
            { code: "34100", label: "Fibres alimentaires (g/100 g)", value: "0" },
            { code: "40000", label: "Lipides (g/100 g)", value: "0" },
            { code: "40302", label: "AG saturés (g/100 g)", value: "0" },
            { code: "40303", label: "AG monoinsaturés (g/100 g)", value: "0" },
            { code: "40304", label: "AG polyinsaturés (g/100 g)", value: "0" },
            { code: "40400", label: "AG 4:0, butyrique (g/100 g)", value: "-" },
            { code: "40600", label: "AG 6:0, caproïque (g/100 g)", value: "-" },
            { code: "40800", label: "AG 8:0, caprylique (g/100 g)", value: "-" },
            { code: "41000", label: "AG 10:0, caprique (g/100 g)", value: "-" },
            { code: "41200", label: "AG 12:0, laurique (g/100 g)", value: "-" },
            { code: "41400", label: "AG 14:0, myristique (g/100 g)", value: "-" },
            { code: "41600", label: "AG 16:0, palmitique (g/100 g)", value: "-" },
            { code: "41800", label: "AG 18:0, stéarique (g/100 g)", value: "-" },
            { code: "41819", label: "AG 18:1 9c (n-9), oléique (g/100 g)", value: "-" },
            { code: "41826", label: "AG 18:2 9c,12c (n-6), linoléique (g/100 g)", value: "-" },
            { code: "41833", label: "AG 18:3 c9,c12,c15 (n-3), alpha-linolénique (g/100 g)", value: "-" },
            { code: "42046", label: "AG 20:4 5c,8c,11c,14c (n-6), arachidonique (g/100 g)", value: "-" },
            { code: "42053", label: "AG 20:5 5c,8c,11c,14c,17c (n-3) EPA (g/100 g)", value: "-" },
            { code: "42263", label: "AG 22:6 4c,7c,10c,13c,16c,19c (n-3) DHA (g/100 g)", value: "-" },
            { code: "51200", label: "Rétinol (µg/100 g)", value: "0" },
            { code: "51330", label: "Beta-Carotène (µg/100 g)", value: "0" },
            { code: "52100", label: "Vitamine D (µg/100 g)", value: "0" },
            { code: "53100", label: "Vitamine E (mg/100 g)", value: "-" },
            { code: "54101", label: "Vitamine K1 (µg/100 g)", value: "-" },
            { code: "54104", label: "Vitamine K2 (µg/100 g)", value: "-" },
            { code: "55100", label: "Vitamine C (mg/100 g)", value: "0" },
            { code: "56100", label: "Vitamine B1 ou Thiamine (mg/100 g)", value: "0" },
            { code: "56200", label: "Vitamine B2 ou Riboflavine (mg/100 g)", value: "0" },
            { code: "56310", label: "Vitamine B3 ou PP ou Niacine (mg/100 g)", value: "0" },
            { code: "56400", label: "Vitamine B5 ou Acide pantothénique (mg/100 g)", value: "0" },
            { code: "56500", label: "Vitamine B6 (mg/100 g)", value: "0" },
            { code: "56600", label: "Vitamine B12 (µg/100 g)", value: "0" },
            { code: "56700", label: "Vitamine B9 ou Folates totaux (µg/100 g)", value: "0" },
            { code: "60000", label: "Alcool (g/100 g)", value: "37,5" },
            { code: "65000", label: "Acides organiques (g/100 g)", value: "0" },
            { code: "75100", label: "Cholestérol (mg/100 g)", value: "0" }
          ]
        }
      ])
    end
  end
end
