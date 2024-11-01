pageextension 50114 PostedSalesShipments extends "Posted Sales Shipments"
{
    layout
    {
    }
    actions
    {
        addfirst(processing)
        {
            action("Export to Excel")
            {
                ApplicationArea = All;
                Visible = true;
                Image = ExportToExcel;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                var
                    //Export: Report "Exp. Sales Shipment (RCL)";
                    ShipmentHeader: Record "Sales Shipment Header";
                begin
                    ShipmentHeader.Reset();
                    ShipmentHeader.SetRange("No.", Rec."No.");
                    ShipmentHeader.SetRange("Posting Date", Rec."Posting Date");
                    //Export.SetTableView(ShipmentHeader);
                    //Export.Run();
                end;
            }
        }
    }
}
