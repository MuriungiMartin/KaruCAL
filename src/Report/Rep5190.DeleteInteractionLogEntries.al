#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 5190 "Delete Interaction Log Entries"
{
    Caption = 'Delete Interaction Log Entries';
    ProcessingOnly = true;
    UsageCategory = Tasks;

    dataset
    {
        dataitem("Interaction Log Entry";"Interaction Log Entry")
        {
            DataItemTableView = sorting(Canceled,"Campaign No.","Campaign Entry No.",Date) where(Canceled=const(true));
            RequestFilterFields = "Entry No.","Contact No.",Date,"Campaign No.","Interaction Group Code","Interaction Template Code","Salesperson Code";
            column(ReportForNavId_3056; 3056)
            {
            }

            trigger OnAfterGetRecord()
            var
                SalesHeader: Record "Sales Header";
                SalesHeaderArchive: Record "Sales Header Archive";
                PurchHeader: Record "Purchase Header";
                PurchHeaderArchive: Record "Purchase Header Archive";
            begin
                if UniqueAttachment then begin
                  Attachment.Get("Attachment No.");
                  Attachment.Delete(true);
                end;
                NoOfInteractions := NoOfInteractions + 1;

                if "Version No." <> 0 then
                  case "Document Type" of
                    "document type"::"Sales Qte.":
                      begin
                        SalesHeaderArchive.Get(
                          SalesHeaderArchive."document type"::Quote,"Document No.",
                          "Doc. No. Occurrence","Version No.");
                        SalesHeader.SetRange("Document Type",SalesHeader."document type"::Quote);
                        SalesHeader.SetRange("No.","Document No.");
                        SalesHeader.SetRange("Doc. No. Occurrence","Doc. No. Occurrence");
                        if SalesHeader.FindFirst then begin
                          SalesHeaderArchive."Interaction Exist" := false;
                          SalesHeaderArchive.Modify;
                        end else
                          SalesHeaderArchive.Delete(true);
                      end;
                    "document type"::"Sales Ord. Cnfrmn.":
                      begin
                        SalesHeaderArchive.Get(
                          SalesHeaderArchive."document type"::Order,"Document No.",
                          "Doc. No. Occurrence","Version No.");
                        SalesHeader.SetRange("Document Type",SalesHeader."document type"::Order);
                        SalesHeader.SetRange("No.","Document No.");
                        SalesHeader.SetRange("Doc. No. Occurrence","Doc. No. Occurrence");
                        if SalesHeader.FindFirst then begin
                          SalesHeaderArchive."Interaction Exist" := false;
                          SalesHeaderArchive.Modify;
                        end else
                          SalesHeaderArchive.Delete(true);
                      end;
                    "document type"::"Purch.Qte.":
                      begin
                        PurchHeaderArchive.Get(
                          PurchHeaderArchive."document type"::Quote,"Document No.",
                          "Doc. No. Occurrence","Version No.");
                        PurchHeader.SetRange("Document Type",PurchHeader."document type"::Quote);
                        PurchHeader.SetRange("No.","Document No.");
                        PurchHeader.SetRange("Doc. No. Occurrence","Doc. No. Occurrence");
                        if PurchHeader.FindFirst then begin
                          PurchHeaderArchive."Interaction Exist" := false;
                          PurchHeaderArchive.Modify;
                        end else
                          PurchHeaderArchive.Delete(true);
                      end;
                    "document type"::"Purch. Ord.":
                      begin
                        PurchHeaderArchive.Get(
                          PurchHeaderArchive."document type"::Order,"Document No.",
                          "Doc. No. Occurrence","Version No.");
                        PurchHeader.SetRange("Document Type",PurchHeader."document type"::Order);
                        PurchHeader.SetRange("No.","Document No.");
                        PurchHeader.SetRange("Doc. No. Occurrence","Doc. No. Occurrence");
                        if PurchHeader.FindFirst then begin
                          PurchHeaderArchive."Interaction Exist" := false;
                          PurchHeaderArchive.Modify;
                        end else
                          PurchHeaderArchive.Delete(true);
                      end;
                  end;
                Delete(true);
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPostReport()
    begin
        Message(Text000,NoOfInteractions,"Interaction Log Entry".TableCaption);
    end;

    var
        Text000: label '%1 %2 has been deleted.';
        Attachment: Record Attachment;
        NoOfInteractions: Integer;
}

