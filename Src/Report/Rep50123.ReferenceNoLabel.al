report 50123 "Reference No Label"
{
    Caption = 'Reference No Label';
    UsageCategory = Tasks;
    ApplicationArea = All;
    // WordMergeDataItem = ItemReference;
    // DefaultRenderingLayout = Word;
    RDLCLayout = './LayoutReport/RefferenNoLabel.rdl';
    DefaultLayout = RDLC;

    dataset
    {
        dataitem(ItemReference; "Item Reference")
        {
            DataItemTableView = sorting("Item No.");
            RequestFilterFields = "Item No.";
            RequestFilterHeading = 'ItemReference';

            // Column that provides the data string for the barcode
            column(Item_No_; "Item No.")
            {
            }
            column(Description; Description)
            {

            }
            column(Unit_of_Measure; "Unit of Measure")
            {

            }
            column(Reference_No_; ReferenceNoCode)
            {

            }
            column(Reference_No_2D; ReferenceNoQRCode)
            {

            }
            trigger OnAfterGetRecord()
            var
                Item: Record Item;
                BarcodeString: Text;
                BarcodeFontProvider: Interface "Barcode Font Provider";
                BarcodeFontProvider2D: Interface "Barcode Font Provider 2D";

            begin
                //GenerateCode39();
                // Declare the barcode provider using the barcode provider interface and enum
                BarcodeFontProvider := Enum::"Barcode Font Provider"::IDAutomation1D;
                BarcodeFontProvider2D := Enum::"Barcode Font Provider 2D"::IDAutomation2D;

                // Set data string source 
                if "Reference No." <> '' then begin
                    BarcodeString := "Reference No.";
                    // Validate the input
                    BarcodeFontProvider.ValidateInput(BarcodeString, BarcodeSymbology);

                    // Encode the data string to the barcode font
                    ReferenceNoCode := BarcodeFontProvider.EncodeFont(BarcodeString, BarcodeSymbology);
                    ReferenceNoQRCode := BarcodeFontProvider2D.EncodeFont(BarcodeString, BarcodeSymbology2D);
                end;

                if Description = '' then begin
                    Item.SetLoadFields(Item.Description);
                    Item.Get("Item No.");
                    Description := Item.Description;
                end
            end;

        }
    }
    // local procedure GenerateCode39()
    // var
    //     BarcodeSymbology: Enum "Barcode Symbology";
    //     BarcodeFontProvider: Interface "Barcode Font Provider";
    //     BarcodeString: Text;
    //     Item: Record Item;
    // begin
    //     BarcodeFontProvider := Enum::"Barcode Font Provider"::IDAutomation1D;
    //     BarcodeSymbology := Enum::"Barcode Symbology"::Code39;
    //     BarcodeString := Item."No.";
    //     BarcodeFontProvider.ValidateInput(BarcodeString, BarcodeSymbology);
    //     EncodeTextCode39 := BarcodeFontProvider.EncodeFont(BarcodeString, BarcodeSymbology);
    // end;
    // rendering
    // {
    //     layout(Word)
    //     {
    //         Type = Word;
    //         LayoutFile = './LayoutReport/ReferenceNoLabel.docx';
    //     }
    // }

    var
        BarcodeSymbology: Enum "Barcode Symbology";
        BarcodeSymbology2D: Enum "Barcode Symbology 2D";
        ReferenceNoCode: Text;
        ReferenceNoQRCode: Text;
    //EncodeTextCode39: Text;


    trigger OnInitReport()
    begin
        BarcodeSymbology := Enum::"Barcode Symbology"::Code128;
        BarcodeSymbology2D := Enum::"Barcode Symbology 2D"::"QR-Code";
    end;
}
