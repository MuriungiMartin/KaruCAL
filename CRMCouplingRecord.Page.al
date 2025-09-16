#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5336 "CRM Coupling Record"
{
    Caption = 'CRM Coupling Record';
    PageType = StandardDialog;
    SourceTable = "Coupling Record Buffer";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            group(Control11)
            {
                grid(Coupling)
                {
                    Caption = 'Coupling';
                    GridLayout = Columns;
                    group("Dynamics NAV")
                    {
                        Caption = 'Dynamics NAV';
                        field(NAVName;"NAV Name")
                        {
                            ApplicationArea = Suite;
                            Caption = 'Dynamics NAV Name';
                            Editable = false;
                            ShowCaption = false;
                            ToolTip = 'Specifies the name of the record in Dynamics NAV to couple to an existing Dynamics CRM record.';
                        }
                        group(Control13)
                        {
                            field(SyncActionControl;"Sync Action")
                            {
                                ApplicationArea = Suite;
                                Caption = 'Synchronize After Coupling';
                                Enabled = not "Create New";
                                OptionCaption = 'No,Yes - Use the Dynamics NAV data,Yes - Use the Dynamics CRM data';
                                ToolTip = 'Specifies whether to synchronize the data in the record in Dynamics NAV and the record in Dynamics CRM.';
                            }
                        }
                    }
                    group("Dynamics CRM")
                    {
                        Caption = 'Dynamics CRM';
                        field(CRMName;"CRM Name")
                        {
                            ApplicationArea = Suite;
                            Caption = 'Dynamics CRM Name';
                            Enabled = not "Create New";
                            ShowCaption = false;
                            ToolTip = 'Specifies the name of the record in Dynamics CRM that is coupled to the record in Dynamics NAV.';

                            trigger OnValidate()
                            begin
                                RefreshFields
                            end;
                        }
                        group(Control15)
                        {
                            field(CreateNewControl;"Create New")
                            {
                                ApplicationArea = Suite;
                                Caption = 'Create New';
                                ToolTip = 'Specifies if a new record in Dynamics CRM is automatically created and coupled to the related record in Dynamics NAV.';
                            }
                        }
                    }
                }
            }
            part(CoupledFields;"CRM Coupled Fields")
            {
                ApplicationArea = Suite;
                Caption = 'Fields';
                ShowFilter = false;
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        RefreshFields
    end;


    procedure GetCRMId(): Guid
    begin
        exit("CRM ID");
    end;


    procedure GetPerformInitialSynchronization(): Boolean
    begin
        exit(Rec.GetPerformInitialSynchronization);
    end;


    procedure GetInitialSynchronizationDirection(): Integer
    begin
        exit(Rec.GetInitialSynchronizationDirection);
    end;

    local procedure RefreshFields()
    begin
        CurrPage.CoupledFields.Page.SetSourceRecord(Rec);
    end;


    procedure SetSourceRecordID(RecordID: RecordID)
    begin
        Initialize(RecordID);
        Insert;
    end;
}

