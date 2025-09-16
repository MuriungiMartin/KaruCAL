#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68263 "FIN-Imprest Buffer Surrender"
{
    ApplicationArea = Basic;
    DeleteAllowed = true;
    Editable = true;
    InsertAllowed = true;
    ModifyAllowed = true;
    PageType = List;
    SourceTable = UnknownTable61610;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(No;No)
                {
                    ApplicationArea = Basic;
                }
                field(Type;Type)
                {
                    ApplicationArea = Basic;
                }
                field("Pay Mode";"Pay Mode")
                {
                    ApplicationArea = Basic;
                }
                field("Account Type";"Account Type")
                {
                    ApplicationArea = Basic;
                }
                field("Account No.";"Account No.")
                {
                    ApplicationArea = Basic;
                }
                field("Global Dimension 1 Code";"Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                }
                field("Global Dimension 2 Code";"Global Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                }
                field("Account No:";"Account No:")
                {
                    ApplicationArea = Basic;
                }
                field(Grouping;Grouping)
                {
                    ApplicationArea = Basic;
                }
                field("Payment Type";"Payment Type")
                {
                    ApplicationArea = Basic;
                }
                field("Account Name";"Account Name")
                {
                    ApplicationArea = Basic;
                }
                field("Imprest Issue Date";"Imprest Issue Date")
                {
                    ApplicationArea = Basic;
                }
                field("Imprest Issue Doc. No";"Imprest Issue Doc. No")
                {
                    ApplicationArea = Basic;
                }
                field(Amount;Amount)
                {
                    ApplicationArea = Basic;
                }
                field("Surrender Date";"Surrender Date")
                {
                    ApplicationArea = Basic;
                }
                field("Actual Spent";"Actual Spent")
                {
                    ApplicationArea = Basic;
                }
                field("Cash Surrender Amt";"Cash Surrender Amt")
                {
                    ApplicationArea = Basic;
                }
                field("Imprest Type";"Imprest Type")
                {
                    ApplicationArea = Basic;
                }
                field("Cash Receipt Amount";"Cash Receipt Amount")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action(impImpSur)
            {
                ApplicationArea = Basic;
                Caption = 'Import Imp. Surrender';
                Image = ImportExcel;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                             if Confirm('Import Imprest Surrender?',false)=false then Error('Cancelled by user...');
                            Xmlport.Run(50057,false,true);
                end;
            }
            action(confImp)
            {
                ApplicationArea = Basic;
                Caption = 'Confirm Imports';
                Image = PostBatch;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    if Confirm('These will send the Imports to the Imprest Surrenders, Continue?',true)=false then Error('Cancelled by user....');

                      bufferHeader.Reset;
                      bufferHeader.SetFilter(bufferHeader.Posted,'<>%1',true);
                    if bufferHeader.Find('-') then begin
                      repeat
                      begin
                      // Insert PV Header
                      ImoSurrHeader.Init;
                      ImoSurrHeader.No:=bufferHeader.No;
                      ImoSurrHeader."Surrender Date":=bufferHeader."Surrender Date";
                      ImoSurrHeader.Type:=bufferHeader.Type;
                      ImoSurrHeader."Pay Mode":=bufferHeader."Pay Mode";
                      ImoSurrHeader."Received From":= bufferHeader."Account Name";
                      ImoSurrHeader."On Behalf Of"   :=bufferHeader."Account Name";
                      ImoSurrHeader."Account Type"     :=bufferHeader."Account Type";
                      ImoSurrHeader."Account No.":=bufferHeader."Account No.";
                      ImoSurrHeader."Account Name":=bufferHeader."Account Name";
                      ImoSurrHeader.Amount:=bufferHeader.Amount;
                      ImoSurrHeader."Net Amount":= bufferHeader.Amount;
                      ImoSurrHeader."Global Dimension 1 Code":=bufferHeader."Global Dimension 1 Code";
                      ImoSurrHeader."Global Dimension 2 Code"  := bufferHeader."Global Dimension 2 Code";
                      ImoSurrHeader.Grouping:=bufferHeader.Grouping;
                      ImoSurrHeader."Payment Type":=bufferHeader."Payment Type";
                      ImoSurrHeader."Imprest Issue Date":=bufferHeader."Imprest Issue Date";
                      ImoSurrHeader."Imprest Issue Doc. No":=bufferHeader."Imprest Issue Doc. No";
                      ImoSurrHeader.Insert;
                         lineNo:=0;
                    // Insert impSurr Lines
                    ImpSurrLines.Init;
                    ImpSurrLines."Surrender Doc No." :=bufferHeader.No;
                    ImpSurrLines."Account No:":=bufferHeader."Account No.";
                    ImpSurrLines."Account Name":=bufferHeader."Account Name";
                    ImpSurrLines.Amount:=bufferHeader.Amount;
                    ImpSurrLines."Due Date":= bufferHeader."Surrender Date";
                    ImpSurrLines."Imprest Holder":=bufferHeader."Account Name";
                    ImpSurrLines."Actual Spent":=  bufferHeader."Actual Spent";
                    ImpSurrLines."Surrender Date":=bufferHeader."Surrender Date";
                    ImpSurrLines."Date Issued":= bufferHeader."Imprest Issue Date";
                    ImpSurrLines."Imprest Type":=bufferHeader.Type;
                     ImpSurrLines.Insert;

                    bufferHeader.Posted:=true;
                    bufferHeader.Modify;

                      end;
                      until bufferHeader.Next=0;
                    end;
                                         Message('Updated Successfully!');
                end;
            }
        }
    }

    var
        bufferHeader: Record UnknownRecord61610;
        ImoSurrHeader: Record UnknownRecord61504;
        ImpSurrLines: Record UnknownRecord61733;
        lineNo: Integer;
}

