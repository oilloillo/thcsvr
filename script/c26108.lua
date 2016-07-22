--守护与被守护的大轮✿云山
function c26108.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--SetCard
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_ADD_SETCODE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_MZONE+LOCATION_PZONE)
	e1:SetValue(0x251)
	c:RegisterEffect(e1)
	--cannot spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetTargetRange(1,0)
	e2:SetCondition(c26108.sccon)
	e2:SetTarget(c26108.splimit)
	--c:RegisterEffect(e2)
	--equip
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26108,0))
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_PZONE)
	e3:SetTarget(c26108.eqtg)
	e3:SetOperation(c26108.eqop)
	c:RegisterEffect(e3)
	--indes
	local e4=Effect.CreateEffect(c)
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_PZONE)
	e4:SetTargetRange(LOCATION_ONFIELD,0)
	e4:SetTarget(c26108.tg)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	--Atk up
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_EQUIP)
	e5:SetCode(EFFECT_UPDATE_ATTACK)
	e5:SetValue(1500)
	c:RegisterEffect(e5)
	--Def up
	local e6=e5:Clone()
	e6:SetCode(EFFECT_UPDATE_DEFENCE)
	c:RegisterEffect(e6)
	--destroy
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(26108,1))
	e7:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_DAMAGE_STEP)
	e7:SetCode(EVENT_SUMMON_SUCCESS)
	e7:SetOperation(c26108.poop)
	c:RegisterEffect(e7)
	--Untargetable
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_EQUIP)
	e8:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e8:SetValue(1)
	c:RegisterEffect(e8)
	--destroy sub
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_EQUIP)
	e9:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e9:SetCode(EFFECT_DESTROY_SUBSTITUTE)
	e9:SetValue(1)
	c:RegisterEffect(e9)
	--eqlimit
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_SINGLE)
	e10:SetCode(EFFECT_EQUIP_LIMIT)
	e10:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e10:SetValue(c26108.eqlimit)
	c:RegisterEffect(e10)
end
function c26108.eqlimit(e,c)
	return c:IsSetCard(0x251a)
end
function c26108.sccon(e)
	local seq=e:GetHandler():GetSequence()
	local tc=Duel.GetFieldCard(e:GetHandlerPlayer(),LOCATION_SZONE,13-seq)
	return not tc or tc:GetOriginalAttribute()==e:GetHandler():GetOriginalAttribute()
end
function c26108.splimit(e,c,tp,sumtp,sumpos)
	return bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c26108.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x251a) and c:GetUnionCount()==0
end
function c26108.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c26108.filter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c26108.filter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c26108.filter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c26108.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	if not tc:IsRelateToEffect(e) or not c26108.filter(tc) then
		Duel.SendtoGrave(c,REASON_EFFECT)
		return
	end
	if not Duel.Equip(tp,c,tc,false) then return end
	c:SetStatus(STATUS_UNION,true)
end
function c26108.tg(e,c)
	return c:IsSetCard(0x251a)
end
function c26108.poop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(26108,2))
	e7:SetCategory(CATEGORY_DESTROY)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e7:SetRange(LOCATION_MZONE)
	e7:SetProperty(EFFECT_FLAG_REPEAT)
	e7:SetCountLimit(1)
	e7:SetCode(EVENT_PHASE+PHASE_END)
	e7:SetTarget(c26108.destg)
	e7:SetOperation(c26108.desop)
	c:RegisterEffect(e7)
end
function c26108.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function c26108.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		Duel.Destroy(c,REASON_EFFECT)
	end
end