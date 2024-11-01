pageextension 50103 VendorExt extends "Vendor List"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
        addfirst(processing)
        {
            action(Export)
            {
                ApplicationArea = All;
                Caption = 'Export', comment = 'NLB="YourLanguageCaption"';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Export;
                ToolTip = 'Export To excel';

                trigger OnAction()
                begin
                    ExportExcel(Rec);
                end;
            }
        }
    }
    local procedure ExportExcel(var GSExcel: Record Vendor)
    var
        TempExcelBuffer: Record "Excel Buffer" temporary;
        GSExcelLbl: Label 'GS Excel Vendor';
        GSFileName: Label 'GS Excel Vendor_%1_%2';
    begin
        TempExelBuffer.Reset();
        TempExelBuffer.DeleteAll();
        TempExelBuffer.NewRow();

        TempExelBuffer.AddColumn(GSExcel.FieldCaption("No."), false, '', false, false, false, '', TempExelBuffer."Cell Type"::Text);
        TempExelBuffer.AddColumn(GSExcel.FieldCaption(Name), false, '', false, false, false, '', TempExelBuffer."Cell Type"::Text);
        TempExelBuffer.AddColumn(GSExcel.FieldCaption(Contact), false, '', false, false, false, '', TempExelBuffer."Cell Type"::Text);
        TempExelBuffer.AddColumn(GSExcel.FieldCaption("Balance (LCY)"), false, '', false, false, false, '', TempExelBuffer."Cell Type"::Text);
        TempExelBuffer.AddColumn(GSExcel.FieldCaption("Balance Due (LCY)"), false, '', false, false, false, '', TempExelBuffer."Cell Type"::Text);
        TempExelBuffer.AddColumn(GSExcel.FieldCaption("Payments (LCY)"), false, '', false, false, false, '', TempExelBuffer."Cell Type"::Text);

        if GSExcel.FindSet() then
            repeat
                TempExelBuffer.NewRow();
                TempExelBuffer.AddColumn(GSExcel."No.", false, '', false, false, false, '', TempExelBuffer."Cell Type"::Text);
                TempExelBuffer.AddColumn(GSExcel.Name, false, '', false, false, false, '', TempExelBuffer."Cell Type"::Text);
                TempExelBuffer.AddColumn(GSExcel.Contact, false, '', false, false, false, '', TempExelBuffer."Cell Type"::Text);
                TempExelBuffer.AddColumn(GSExcel."Balance (LCY)", false, '', false, false, false, '', TempExelBuffer."Cell Type"::Text);
                TempExelBuffer.AddColumn(GSExcel."Balance Due (LCY)", false, '', false, false, false, '', TempExelBuffer."Cell Type"::Text);
                TempExelBuffer.AddColumn(GSExcel."Payments (LCY)", false, '', false, false, false, '', TempExelBuffer."Cell Type"::Text);
            until GSExcel.Next() = 0;

        TempExelBuffer.CreateNewBook(GSExcelLbl);
        TempExelBuffer.WriteSheet(GSExcelLbl, CompanyName, UserId);
        TempExelBuffer.CloseBook();
        TempExelBuffer.SetFriendlyFilename(StrSubstNo(GSFileName, CurrentDateTime, UserId));
        TempExelBuffer.OpenExcel();
    end;

    var
        myInt: Integer;
        TempExelBuffer: Record "Excel Buffer" temporary;
}