#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 5194 "Create Conts. from Vendors"
{
    Caption = 'Create Conts. from Vendors';
    ProcessingOnly = true;
    UsageCategory = Tasks;

    dataset
    {
        dataitem(Vendor;Vendor)
        {
            RequestFilterFields = "No.","Search Name","Vendor Posting Group","Currency Code";
            column(ReportForNavId_3182; 3182)
            {
            }

            trigger OnAfterGetRecord()
            begin
                Window.Update(1);

                with ContBusRel do begin
                  SetRange("Link to Table","link to table"::Vendor);
                  SetRange("No.",Vendor."No.");
                  if FindFirst then
                    CurrReport.Skip;
                end;

                Cont.Init;
                Cont.TransferFields(Vendor);
                Cont."No." := '';
                Cont.SetSkipDefault;
                Cont.Insert(true);
                DuplMgt.MakeContIndex(Cont);

                if not DuplicateContactExist then
                  DuplicateContactExist := DuplMgt.DuplicateExist(Cont);

                with ContBusRel do begin
                  Init;
                  "Contact No." := Cont."No.";
                  "Business Relation Code" := RMSetup."Bus. Rel. Code for Vendors";
                  "Link to Table" := "link to table"::Vendor;
                  "No." := Vendor."No.";
                  Insert;
                end;
            end;

            trigger OnPostDataItem()
            begin
                Window.Close;

                if DuplicateContactExist then begin
                  Commit;
                  Page.RunModal(Page::"Contact Duplicates");
                end;
            end;

            trigger OnPreDataItem()
            begin
                Window.Open(Text000 +
                  Text001,"No.");
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

    trigger OnPreReport()
    begin
        RMSetup.Get;
        RMSetup.TestField("Bus. Rel. Code for Vendors");
    end;

    var
        Text000: label 'Processing vendors...\\';
        Text001: label 'Vendor No.      #1##########';
        RMSetup: Record "Marketing Setup";
        Cont: Record Contact;
        ContBusRel: Record "Contact Business Relation";
        DuplMgt: Codeunit DuplicateManagement;
        Window: Dialog;
        DuplicateContactExist: Boolean;
}

