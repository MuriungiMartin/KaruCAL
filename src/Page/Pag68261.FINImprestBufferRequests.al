#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68261 "FIN-Imprest Buffer Requests"
{
    ApplicationArea = Basic;
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = UnknownTable61508;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                }
                field(Date;Date)
                {
                    ApplicationArea = Basic;
                }
                field(Payee;Payee)
                {
                    ApplicationArea = Basic;
                }
                field("On Behalf Of";"On Behalf Of")
                {
                    ApplicationArea = Basic;
                }
                field(Posted;Posted)
                {
                    ApplicationArea = Basic;
                }
                field("Posted By";"Posted By")
                {
                    ApplicationArea = Basic;
                }
                field("Global Dimension 1 Code";"Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                }
                field("Payment Type";"Payment Type")
                {
                    ApplicationArea = Basic;
                }
                field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                }
                field("Document Type";"Document Type")
                {
                    ApplicationArea = Basic;
                }
                field("Responsibility Center";"Responsibility Center")
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
                field("Surrender Status";"Surrender Status")
                {
                    ApplicationArea = Basic;
                }
                field(Purpose;Purpose)
                {
                    ApplicationArea = Basic;
                }
                field("Advance Type";"Advance Type")
                {
                    ApplicationArea = Basic;
                }
                field("Requested By";"Requested By")
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
            action(impImp)
            {
                ApplicationArea = Basic;
                Caption = 'Import Imprests';
                Image = ImportExcel;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                             if Confirm('Import Imprests?',false)=false then Error('Cancelled by user...');
                             Xmlport.Run(50056,false,true);
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
                    if Confirm('These will send the Imports to the Imprests, Continue?',true)=false then Error('Cancelled by user....');

                      bufferHeader.Reset;
                      bufferHeader.SetFilter(bufferHeader.Posted,'<>%1',true);
                    if bufferHeader.Find('-') then begin
                      repeat
                      begin
                      // Insert PV Header
                      ImprestHeader.Init;
                      ImprestHeader."No.":=bufferHeader."No.";
                      ImprestHeader.Date:=bufferHeader.Date;
                      ImprestHeader.Payee:=bufferHeader.Payee;
                      ImprestHeader."On Behalf Of":=bufferHeader."On Behalf Of";
                      ImprestHeader."Global Dimension 1 Code":=bufferHeader."Global Dimension 1 Code";
                      ImprestHeader.Status:=ImprestHeader.Status::Pending;
                      ImprestHeader."Payment Type":=bufferHeader."Payment Type";
                      ImprestHeader."Shortcut Dimension 2 Code":=bufferHeader."Shortcut Dimension 2 Code";
                      ImprestHeader."Responsibility Center":='MAIN';
                      ImprestHeader."Account Type":=bufferHeader."Account Type";
                      ImprestHeader."Account No.":=bufferHeader."Account No.";
                      ImprestHeader.Purpose:=bufferHeader.Purpose;
                      ImprestHeader.Insert;

                         lineNo:=0;
                    // Insert Imp Lines
                    ImprestDet.Init;
                    ImprestDet.No:=ImprestDet.No;
                    ImprestDet."Advance Type":=ImprestDet."Advance Type";
                    ImprestDet."Shortcut Dimension 2 Code":=ImprestDet."Shortcut Dimension 2 Code";
                    ImprestDet."Global Dimension 1 Code":=ImprestDet."Global Dimension 1 Code";
                    ImprestDet."Account No:":=ImprestDet."Account No:";
                    ImprestDet."Account Name":=ImprestDet."Account Name";
                    ImprestDet.Amount:=ImprestDet.Amount;
                    ImprestDet."Due Date":=bufferHeader.Date;
                    ImprestDet."Imprest Holder":=ImprestDet."Imprest Holder";
                    ImprestDet."Date Issued":=bufferHeader.Date;
                    ImprestDet."Due Date":=ImprestDet."Due Date";
                    ImprestDet.Insert;
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
        bufferHeader: Record UnknownRecord61508;
        ImprestHeader: Record UnknownRecord61704;
        ImprestDet: Record UnknownRecord61714;
        lineNo: Integer;
}

