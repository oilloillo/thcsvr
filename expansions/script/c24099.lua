--空想上的人格保持者✿古明地恋
function c24099.initial_effect(c)
	--synlimit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetValue(c24099.synlimit)
	c:RegisterEffect(e0)
	--sp
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetDescription(aux.Stringid(24099,0))
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c24099.spcon)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(24099,1))
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_LVCHANGE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c24099.attg)
	e2:SetOperation(c24099.atop)
	c:RegisterEffect(e2)
end
function c24099.synlimit(e,c)
	if not c then return false end
	return not c:IsSetCard(0x625) and not c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c24099.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return not Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_MZONE,0,1,nil)
end
function c24099.afilter(c,atk)
	return (c:IsSetCard(0x625) or c:GetAttack()<atk) and c:IsFaceup()
end
function c24099.attg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
		and Duel.IsExistingMatchingCard(c24099.afilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler(),e:GetHandler():GetAttack()) end
	
end
function c24099.atop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local g=Duel.GetMatchingGroup(c24099.afilter,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler(),c:GetAttack())
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(g:GetCount()*500)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		local lvl=g:GetCount()
		if c:GetLevel()-lvl<1 then lvl=c:GetLevel()-1 end
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_LEVEL)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e2:SetValue(-lvl)
		c:RegisterEffect(e2)
	end
end