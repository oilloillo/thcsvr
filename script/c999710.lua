--路边的岩石
local M = c999710
local Mid = 999710
function M.initial_effect(c)
	--self destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(Mid,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetCondition(M.condition)
	e1:SetTarget(M.target)
	e1:SetOperation(M.operation)
	c:RegisterEffect(e1)
	--equip 
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(Mid,1))
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_HAND)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,0x1e0)
	e2:SetTarget(M.eqtg)
	e2:SetOperation(M.eqop)
	c:RegisterEffect(e2)
	--equip effect
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(800)
	c:RegisterEffect(e3)
end

function M.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOwner()~=tp
end

function M.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end

function M.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		if Duel.Destroy(c, REASON_EFFECT)>0 then
			Duel.Damage(tp, 800, REASON_EFFECT)
		end
	end
end

function M.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xaa5)
end

function M.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and M.filter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and not e:GetHandler():IsStatus(STATUS_CHAINING)
		and Duel.IsExistingTarget(M.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,M.filter,tp,LOCATION_MZONE,0,1,1,nil)
end

function M.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or tc:IsFacedown() or not tc:IsRelateToEffect(e) or not tc:IsControler(tp) then
		Duel.SendtoGrave(c,REASON_EFFECT)
		return
	end
	Duel.Equip(tp,c,tc,true)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetValue(M.eqlimit)
	e1:SetLabelObject(tc)
	c:RegisterEffect(e1)
end

function M.eqlimit(e,c)
	return c==e:GetLabelObject()
end