#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 5193 "Create Conts. from Bank Accs."
{
    Caption = 'Create Conts. from Bank Accs.';
    ProcessingOnly = true;
    UsageCategory = Tasks;

    dataset
    {
        dataitem("Bank Account";"Bank Account")
        {
            RequestFilterFields = "No.","Search Name","Bank Acc. Posting Group","Currency Code";
            column(ReportForNavId_4558; 4558)
            {
            }

            trigger OnAfterGetRecord()
            begin
                Window.Update(1);

                with ContBusRel do begin
                  SetRange("Link to Table","link to table"::"Bank Account");
                  SetRange("No.","Bank Account"."No.");
                  if FindFirst then
                    CurrReport.Skip;
                end;

                Cont.Init;
                Cont.TransferFields("Bank Account");
                Cont."No." := '';
                Cont.SetSkipDefault;
                Cont.Insert(true);
                DuplMgt.MakeContIndex(Cont);

                if not DuplicateContactExist then
                  DuplicateContactExist := DuplMgt.DuplicateExist(Cont);

                with ContBusRel do begin
                  Init;
                  "Contact No." := Cont."No.";
                  "Business Relation Code" := RMSetup."Bus. Rel. Code for Bank Accs.";
                  "Link to Table" := "link to table"::"Bank Account";
                  "No." := "Bank Account"."No.";
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
        RMSetup.TestField("Bus. Rel. Code for Bank Accs.");
    end;

    var
        Text000: label 'Processing vendors...\\';
        Text001: label 'Bank Account No.  #1##########';
        RMSetup: Record "Marketing Setup";
        Cont: Record Contact;
        ContBusRel: Record "Contact Business Relation";
        DuplMgt: Codeunit DuplicateManagement;
        Window: Dialog;
        DuplicateContactExist: Boolean;
}

