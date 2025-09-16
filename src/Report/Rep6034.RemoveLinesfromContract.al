#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 6034 "Remove Lines from Contract"
{
    Caption = 'Remove Lines from Contract';
    ProcessingOnly = true;
    UsageCategory = Tasks;

    dataset
    {
        dataitem("Service Contract Line";"Service Contract Line")
        {
            DataItemTableView = sorting("Contract Type","Contract No.",Credited,"New Line") where("Contract Type"=const(Contract),"Contract Status"=const(Signed),"New Line"=const(false));
            RequestFilterFields = "Contract No.","Service Item No.";
            column(ReportForNavId_6062; 6062)
            {
            }

            trigger OnAfterGetRecord()
            begin
                j := j + 1;
                Window.Update(1,ROUND(j / i * 10000,1));

                if LastContractNo <> "Contract No." then begin
                  LastContractNo := "Contract No.";
                  ServContract.Get("Contract Type","Contract No.");
                  FiledServContract.FileContract(ServContract);
                  if ServContract."Automatic Credit Memos" and
                     ("Credit Memo Date" > 0D) and
                     CreditMemoBaseExists
                  then
                    CreditMemoCreated := CreditMemoCreated + 1;
                end;
                SuspendStatusCheck(true);
                Delete(true);

                LinesRemoved := LinesRemoved + 1;
            end;

            trigger OnPreDataItem()
            begin
                if DeleteLines = Deletelines::"Print Only" then begin
                  Clear(ExpiredContractLinesTest);
                  ExpiredContractLinesTest.InitVariables(DelToDate,ReasonCode);
                  ExpiredContractLinesTest.SetTableview("Service Contract Line");
                  ExpiredContractLinesTest.RunModal;
                  CurrReport.Break;
                end;

                if DelToDate = 0D then
                  Error(Text002);
                ServMgtSetup.Get;
                if ServMgtSetup."Use Contract Cancel Reason" then
                  if ReasonCode = '' then
                    Error(Text003);
                SetFilter("Contract Expiration Date",'<>%1&<=%2',0D,DelToDate);

                Window.Open(
                  Text004 +
                  '@1@@@@@@@@@@@@@@@@@@@@@@@@@@@');
                i := Count;
                j := 0;
                LinesRemoved := 0;
                LastContractNo := '';
                CreditMemoCreated := 0;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(DelToDate;DelToDate)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Remove Lines to';
                    }
                    field(ReasonCode;ReasonCode)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Reason Code';

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            ReasonCode2.Reset;
                            ReasonCode2.Code := ReasonCode;
                            if Page.RunModal(0,ReasonCode2) = Action::LookupOK then begin
                              ReasonCode2.Get(ReasonCode2.Code);
                              ReasonCode := ReasonCode2.Code;
                            end;
                        end;

                        trigger OnValidate()
                        begin
                            ReasonCode2.Get(ReasonCode);
                        end;
                    }
                    field("Reason Code";ReasonCode2.Description)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Reason Code Description';
                        Editable = false;
                    }
                    field(DeleteLines;DeleteLines)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Action';
                        OptionCaption = 'Delete Lines,Print Only';
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
        DelToDate := WorkDate;
        ServMgtSetup.Get;
    end;

    trigger OnPostReport()
    begin
        if DeleteLines = Deletelines::"Delete Lines" then
          if LinesRemoved > 1 then
            Message(Text000,LinesRemoved)
          else
            Message(Text001,LinesRemoved);

        if CreditMemoCreated = 1 then
          Message(Text006);

        if CreditMemoCreated > 1 then
          Message(Text007);
        CreateCreditfromContractLines.InitVariables;
    end;

    trigger OnPreReport()
    begin
        CreateCreditfromContractLines.InitVariables;
    end;

    var
        Text000: label '%1 contract lines were removed.';
        Text001: label '%1 contract line was removed.';
        Text002: label 'You must fill in the Remove Lines to field.';
        Text003: label 'You must fill in the Reason Code field.';
        Text004: label 'Removing contract lines... \\';
        ServMgtSetup: Record "Service Mgt. Setup";
        ServContract: Record "Service Contract Header";
        FiledServContract: Record "Filed Service Contract Header";
        ReasonCode2: Record "Reason Code";
        ExpiredContractLinesTest: Report "Expired Contract Lines - Test";
        CreateCreditfromContractLines: Codeunit CreateCreditfromContractLines;
        Window: Dialog;
        i: Integer;
        j: Integer;
        LinesRemoved: Integer;
        DelToDate: Date;
        DeleteLines: Option "Delete Lines","Print Only";
        ReasonCode: Code[10];
        LastContractNo: Code[20];
        Text006: label 'A credit memo was created/updated.';
        CreditMemoCreated: Integer;
        Text007: label 'Credit memos were created/updated.';
}

