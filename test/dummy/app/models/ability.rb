# encoding: UTF-8
class Ability  < Cor1440Gen::Ability

  # Autorizacion con CanCanCan
  def initialize(usuario = nil)
    # Sin autenticación puede consultarse información geográfica 
    can :read, [Sip::Pais, Sip::Departamento, Sip::Municipio, Sip::Clase]
    if !usuario || usuario.fechadeshabilitacion
      return
    end
    can :contar, Sip::Ubicacion
    can :buscar, Sip::Ubicacion
    can :lista, Sip::Ubicacion
    can :descarga_anexo, Sip::Anexo
    can :nuevo, Cor1440Gen::Actividad
    can :nuevo, Sip::Ubicacion
    if !usuario.nil? && !usuario.rol.nil? then
      case usuario.rol 
      when Ability::ROLSISTACT
        can :read, Cor1440Gen::Informe
        can :read, Cor1440Gen::Actividad
        can :new, Cor1440Gen::Actividad
        can [:update, :create, :destroy], Cor1440Gen::Actividad, 
          oficina: { id: usuario.oficina_id}
        can :read, Cor1440Gen::Proyectofinanciero
      when Ability::ROLCOOR
        can :manage, Cor1440Gen::Actividad
        can :manage, Cor1440Gen::Informe
        can [:update, :create, :destroy], Cor1440Gen::Actividad, 
          oficina: { id: usuario.oficina_id}
        can :new, Usuario
        can [:read, :manage], Usuario, oficina: { id: usuario.oficina_id}
        can :read, Cor1440Gen::Proyectofinanciero
      when Ability::ROLINV
        cannot :buscar, Sip::Actividad
        can :read, Sip::Actividad
      when Ability::ROLADMIN, Ability::ROLDIR
        can :manage, Cor1440Gen::Proyectofinanciero
        can :manage, Cor1440Gen::Financiador
        can :manage, Cor1440Gen::Actividad
        can :manage, Cor1440Gen::Informe
        can :manage, Heb412Gen::Doc
        can :manage, :tablasbasicas
        can :manage, Usuario
        can :manage, :tablasbasicas
        tablasbasicas.each do |t|
          c = Ability.tb_clase(t)
          can :manage, c
        end
      end
    end
  end

end

