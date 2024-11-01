pageextension 50105 Item extends "Item List"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
        addbefore("Item Journal")
        {
            action(Export)
            {
                ApplicationArea = All;
                Caption = 'Export', comment = 'NLB="YourLanguageCaption"';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Export;
                ToolTip = 'Export To Excel';

                trigger OnAction()
                begin
                    ExportToExcel(Rec);
                end;
            }
            action("Item Atribute")
            {
                ApplicationArea = All;
                Caption = 'Item Atribute', comment = '="YourLanguageCaption"';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = ShowList;

                trigger OnAction()
                begin
                    FindItemAttribute();
                end;
            }
        }
    }
    local procedure FindItemAttribute()
    var
        ItemAtribute: Record "Item Attribute";
    begin
        ItemAtribute.Reset();
    end;

    local procedure ExportToExcel(var Item: Record Item)
    var
        ExcelBufferTmp: Record "Excel Buffer" temporary;
        GSExcelLbl: Label 'GS Excel Item';
        GSFileName: Label 'GS Excel Item_%1_%2';
    begin
        ExcelBufferTmp.Reset();
        ExcelBufferTmp.DeleteAll();
        ExcelBufferTmp.NewRow();

        ExcelBufferTmp.AddColumn(Item.FieldCaption("No."), false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        ExcelBufferTmp.AddColumn(Item.FieldCaption(Description), false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        ExcelBufferTmp.AddColumn(Item.FieldCaption("Search Description"), false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        ExcelBufferTmp.AddColumn(Item.FieldCaption(Type), false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        ExcelBufferTmp.AddColumn(Item.FieldCaption(Inventory), false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        ExcelBufferTmp.AddColumn(Item.FieldCaption("Base Unit of Measure"), false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        ExcelBufferTmp.AddColumn(Item.FieldCaption("Unit Cost"), false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        ExcelBufferTmp.AddColumn(Item.FieldCaption("Unit Price"), false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        ExcelBufferTmp.AddColumn(Item.FieldCaption("Vendor No."), false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);

        if Item.FindSet() then
            repeat
                ExcelBufferTmp.NewRow();
                ExcelBufferTmp.AddColumn(Item."No.", false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                ExcelBufferTmp.AddColumn(Item.Description, false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                ExcelBufferTmp.AddColumn(Item."Search Description", false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                ExcelBufferTmp.AddColumn(Item.Type, false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                ExcelBufferTmp.AddColumn(Item.Inventory, false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                ExcelBufferTmp.AddColumn(Item."Base Unit of Measure", false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                ExcelBufferTmp.AddColumn(Item."Unit Cost", false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                ExcelBufferTmp.AddColumn(Item."Unit Price", false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                ExcelBufferTmp.AddColumn(Item."Vendor No.", false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
            until Item.Next() = 0;
        ExcelBufferTmp.CreateNewBook(GSExcelLbl);
        ExcelBufferTmp.WriteSheet(GSExcelLbl, CompanyName, UserId);
        ExcelBufferTmp.CloseBook();
        ExcelBufferTmp.SetFriendlyFilename(StrSubstNo(GSFileName, CurrentDateTime, UserId));
        ExcelBufferTmp.OpenExcel();
    end;

    var
        myInt: Integer;
        ExcelBufferTmp: Record "Excel Buffer" temporary;
}