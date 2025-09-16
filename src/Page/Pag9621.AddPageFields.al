#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9621 "Add Page Fields"
{
    Caption = 'New Field';
    DeleteAllowed = false;
    LinksAllowed = false;
    PageType = NavigatePage;
    SourceTable = "Page Table Field";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            group("Select Type")
            {
                Caption = 'Select Type';
                Visible = IsSelectTypeVisible;
                label(NewFieldDescription)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'By adding a new field to the table you can store and display additional information about a data entry.';
                }
                part(FieldTypes;"Table Field Types ListPart")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Choose type of field';
                    Description = 'Choose type of field''';
                    Editable = false;
                }
            }
            group("Step 1")
            {
                Caption = 'Step 1';
                Visible = IsStepOneVisible;
                group("Step 1 of 2")
                {
                    Caption = 'Step 1 of 2';
                    group(Step1Header)
                    {
                        Caption = 'OPTION FIELD DEFINITION';
                        InstructionalText = 'Fill in information about the new field, and choose Next. You can change the field information later if you need to.';
                        field(NewFieldName;NewFieldName)
                        {
                            ApplicationArea = Basic,Suite;
                            Caption = 'Name';
                            ShowMandatory = true;
                        }
                        field(NewFieldCaption;NewFieldCaption)
                        {
                            ApplicationArea = Basic,Suite;
                            Caption = 'Caption';
                        }
                        field(NewDescription;NewFieldDescr)
                        {
                            ApplicationArea = Basic,Suite;
                            Caption = 'Description';
                            MultiLine = true;
                        }
                    }
                }
            }
            group("Step 2")
            {
                Caption = 'Step 2';
                Visible = IsStepTwoVisible;
                group("Step 2 of 2")
                {
                    Caption = 'Step 2 of 2';
                    group(Step2Description)
                    {
                        Caption = 'FIELD VALUES AND VALIDATION';
                        Editable = false;
                        InstructionalText = 'Choose how the system initializes and validates the text that is typed or pasted into the field.';
                    }
                    field(OptionsValue;NewFieldOptionsValue)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Options Value';
                    }
                    field(InitialValue;NewFieldInitialValue)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Initial Value';
                    }
                    field(AllowClearing;NewFieldAllowClearing)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Allow Clearing';
                    }
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Next)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Next';
                Image = NextRecord;
                InFooterBar = true;
                Visible = IsNextVisible;

                trigger OnAction()
                begin
                    IsStepOneVisible := false;
                    IsStepTwoVisible := true;
                    IsBackVisible := true;
                    IsNextVisible := false;
                    IsFinishBtnVisible := true;
                    IsCreateBtnVisible := false;
                end;
            }
            action(Previous)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Previous';
                Image = PreviousRecord;
                InFooterBar = true;
                Visible = IsBackVisible;

                trigger OnAction()
                begin
                    if IsStepTwoVisible then begin
                      IsStepTwoVisible := false;
                      IsStepOneVisible := true;
                      IsBackVisible := true;
                      IsNextVisible := true;
                      IsFinishBtnVisible := false;
                      IsCreateBtnVisible := false;
                    end else
                      if IsStepOneVisible then begin
                        IsStepOneVisible := false;
                        IsSelectTypeVisible := true;
                        IsCreateBtnVisible := true;
                        IsBackVisible := false;
                        IsNextVisible := false;
                        IsFinishBtnVisible := false;
                      end;
                end;
            }
            action(Create)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Create';
                Image = NextRecord;
                InFooterBar = true;
                Visible = IsCreateBtnVisible;

                trigger OnAction()
                begin
                    IsSelectTypeVisible := false;
                    IsStepOneVisible := true;
                    IsStepTwoVisible := false;
                    IsBackVisible := true;
                    IsNextVisible := true;
                    IsCreateBtnVisible := false;
                    IsFinishBtnVisible := false;
                end;
            }
            action(Finish)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Finish';
                Image = Approve;
                InFooterBar = true;
                Visible = IsFinishBtnVisible;

                trigger OnAction()
                begin
                    SaveNewFieldDefinition;
                    CurrPage.Close;
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        DesignerPageId: Codeunit DesignerPageId;
    begin
        IsSelectTypeVisible := true;
        IsStepOneVisible := false;
        IsStepTwoVisible := false;
        IsNextVisible := false;
        IsBackVisible := false;
        IsCreateBtnVisible := true;
        NewFieldAllowClearing := true;
        PageId := DesignerPageId.GetPageId;
    end;

    var
        NavDesigner: dotnet NavDesignerALFunctions;
        IsNextVisible: Boolean;
        IsStepOneVisible: Boolean;
        IsStepTwoVisible: Boolean;
        IsBackVisible: Boolean;
        IsCreateBtnVisible: Boolean;
        IsSelectTypeVisible: Boolean;
        IsFinishBtnVisible: Boolean;
        NewFieldName: Text;
        NewFieldDescr: Text;
        NewFieldCaption: Text;
        NewFieldOptionsValue: Text;
        NewFieldInitialValue: Text;
        NewFieldAllowClearing: Boolean;
        PageId: Integer;
        NewFieldId: Integer;

    local procedure SaveNewFieldDefinition()
    begin
        NewFieldId := NavDesigner.CreateTableField(PageId,NewFieldName,'Option',35,NewFieldDescr);
        if NewFieldId > 0 then begin
          NavDesigner.SetFieldProperty(NewFieldId,'Caption',NewFieldCaption);
          NavDesigner.SetFieldProperty(NewFieldId,'OptionString',NewFieldOptionsValue);
        end;

        if NewFieldId = 0 then
          Error('');
    end;
}

