--绀珠的人类✿雾雨魔理沙
function c31043.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsSetCard,0x200),aux.FilterBoolFunction(Card.IsSetCard,0x208),true)
	--eqiup
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(31043,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c31043.eqcon)
	e1:SetTarget(c31043.eqtg)
	e1:SetOperation(c31043.eqop)
	c:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(c31043.val)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(31043,1))
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c31043.descost)
	e3:SetTarget(c31043.destg)
	e3:SetOperation(c31043.desop)
	c:RegisterEffect(e3)
end
function c31043.ffilter(c)
	return c:IsSetCard(0x208)
end
function c31043.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_FUSION
end
function c31043.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)~=0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function c31043.eqlimit(e,c)
	return e:GetOwner()==c
end
function c31043.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetDecktopGroup(1-tp,1)
	local tc=g:GetFirst()
	if not tc or Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	if c:IsRelateToEffect(e) and tc:IsAbleToChangeControler() then
		Duel.Equip(tp,tc,c,false)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(c31043.eqlimit)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CANNOT_TRIGGER)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		e2:SetValue(1)
		tc:RegisterEffect(e2)
	end
end
function c31043.val(e,c)
	return c:GetEquipCount()*300
end
function c31043.cfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsLocation(LOCATION_SZONE) and c:IsAbleToGraveAsCost()
end
function c31043.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=c:GetEquipGroup()
	if chk==0 then return g:IsExists(c31043.cfilter,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=g:Select(tp,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c31043.filter(c)
	return c:IsDestructable() and c:GetAttack()>=2800
end
function c31043.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c31043.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c31043.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c31043.filter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c31043.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
