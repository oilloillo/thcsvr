 
--潜水舰-伊58
function c50305.initial_effect(c)
	local temp = 0
	while temp<8 do
		c:RegisterFlagEffect(50200,0,0,0)
		temp = temp+1
	end
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(50305,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c50305.atcost)
	e2:SetTarget(c50305.attg)
	e2:SetOperation(c50305.atop)
	c:RegisterEffect(e2)
	--indestructable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--cannot special summon
	local e4=Effect.CreateEffect(c)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SINGLE_RANGE)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCode(EFFECT_SPSUMMON_CONDITION)
	e4:SetValue(aux.FALSE)
	c:RegisterEffect(e4)
	--atk
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(c50305.afilter)
	c:RegisterEffect(e5)
	--cannot be target
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCondition(c50305.condition)
	e6:SetValue(c50305.efilter)
	c:RegisterEffect(e6)
	--adjust
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e7:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e7:SetCode(EVENT_ADJUST)
	e7:SetRange(LOCATION_MZONE)
	e7:SetOperation(c50305.adjustop)
	c:RegisterEffect(e7)
end
function c50305.atcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c50305.desfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDestructable() and c:IsFaceup()
end
function c50305.attg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and c50305.desfilter(chkc) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(c50305.desfilter,tp,0,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c50305.desfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c50305.atop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c50305.afilter(e,c)
	return c:GetLevel()>=5 or c:GetLevel()<1
end
function c50305.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetEquipCount()>0
end
function c50305.efilter(e,re)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsHasCategory(CATEGORY_EQUIP)
end
function c50305.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local phase=Duel.GetCurrentPhase()
	if (phase==PHASE_DAMAGE and not Duel.IsDamageCalculated()) or phase==PHASE_DAMAGE_CAL then return end
	if e:GetHandler():GetEquipCount()>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=e:GetHandler():GetEquipGroup()
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoGrave(sg,REASON_EFFECT)
		Duel.Readjust()
	end
end
