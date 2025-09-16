#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5959 "Standard Serv. Item Gr. Codes"
{
    Caption = 'Standard Serv. Item Gr. Codes';
    DataCaptionExpression = FormCaption;
    DelayedInsert = true;
    PageType = Worksheet;
    SourceTable = "Standard Service Item Gr. Code";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(CurrServItemGroupCodeCtrl;CurrentServiceItemGroupCode)
                {
                    ApplicationArea = Basic;
                    Caption = 'Service Item Group Code';
                    Editable = CurrServItemGroupCodeCtrlEdita;
                    TableRelation = "Service Item Group".Code;
                    ToolTip = 'Specifies the filter that can be applied to sort a list of standard service codes.';

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        CurrPage.SaveRecord;
                        LookupServItemGroupCode;
                        CurrPage.Update(false);
                    end;

                    trigger OnValidate()
                    begin
                        CurrentServiceItemGroupCodeOnA;
                    end;
                }
            }
            repeater(Control1)
            {
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Identifies a standard service code assigned to the specified service item group.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    DrillDown = false;
                    Editable = false;
                    ToolTip = 'Specifies a description of service denoted by the standard service code.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207;Links)
            {
                Visible = false;
            }
            systempart(Control1905767507;Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Service")
            {
                Caption = '&Service';
                Image = Tools;
                action(Card)
                {
                    ApplicationArea = Basic;
                    Caption = 'Card';
                    Image = EditLines;
                    ShortCutKey = 'Shift+F7';

                    trigger OnAction()
                    var
                        StandardServiceCode: Record "Standard Service Code";
                    begin
                        TestField(Code);

                        StandardServiceCode.Get(Code);
                        Page.Run(Page::"Standard Service Code Card",StandardServiceCode);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        SetServItemGroupCode(GetFilter("Service Item Group Code"),false);
    end;

    trigger OnAfterGetRecord()
    begin
        SetServItemGroupCode(GetFilter("Service Item Group Code"),false);
    end;

    trigger OnInit()
    begin
        CurrServItemGroupCodeCtrlEdita := true;
    end;

    trigger OnQueryClosePage(CloseAction: action): Boolean
    var
        NotCloseForm2: Boolean;
    begin
        NotCloseForm2 := NotCloseForm;
        NotCloseForm := false;
        if CurrPage.LookupMode then
          exit(not NotCloseForm2);
    end;

    var
        ServiceItemGroup: Record "Service Item Group";
        CurrentServiceItemGroupCode: Code[10];
        NotCloseForm: Boolean;
        FormCaption: Text[250];
        [InDataSet]
        CurrServItemGroupCodeCtrlEdita: Boolean;

    local procedure LookupServItemGroupCode()
    begin
        Commit;
        if Page.RunModal(0,ServiceItemGroup) = Action::LookupOK then begin
          CurrentServiceItemGroupCode := ServiceItemGroup.Code;
          SetServItemGroupCode(CurrentServiceItemGroupCode,true);
        end;
    end;


    procedure SetServItemGroupCode(NewCode: Code[10];Forced: Boolean)
    begin
        if Forced or (NewCode = '') or (NewCode <> CurrentServiceItemGroupCode) then begin
          CurrentServiceItemGroupCode := NewCode;
          ComposeFormCaption(NewCode);

          if CurrentServiceItemGroupCode = '' then begin
            Reset;
            FilterGroup := 2;
            SetFilter("Service Item Group Code",'''''');
            FilterGroup := 0;
          end else begin
            Reset;
            SetRange("Service Item Group Code",CurrentServiceItemGroupCode);
          end;
        end;
    end;

    local procedure ComposeFormCaption(NewCode: Code[10])
    begin
        if NewCode <> '' then begin
          ServiceItemGroup.Get(NewCode);
          FormCaption := NewCode + ' ' + ServiceItemGroup.Description;
        end else
          FormCaption := '';
    end;

    local procedure CurrentServiceItemGroupCodeOnA()
    begin
        SetServItemGroupCode(CurrentServiceItemGroupCode,true);
        CurrPage.Update(false);
        NotCloseForm := true;
    end;
}

