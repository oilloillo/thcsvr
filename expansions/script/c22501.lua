--夜与血雾的连结✿蕾米莉亚
function c22501.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x813),2)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22501,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c22501.condition)
	e1:SetTarget(c22501.target)
	e1:SetOperation(c22501.operation)
	c:RegisterEffect(e1)
	--blood
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_LEAVE_FIELD_P)
	e2:SetOperation(c22501.regop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22501,1))
	e3:SetCategory(CATEGORY_RECOVER)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetRange(LOCATION_MZONE)
	e3:SetLabelObject(e2)
	e3:SetCondition(c22501.blcon)
	e3:SetTarget(c22501.tg)
	e3:SetOperation(c22501.blop)
	c:RegisterEffect(e3)
	--destroy replace
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(c22501.desreptg)
	e4:SetOperation(c22501.desrepop)
	c:RegisterEffect(e4)
	--damage
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(22501,3))
	e5:SetCategory(CATEGORY_DAMAGE)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetCountLimit(1)
	e5:SetTarget(c22501.damtg)
	e5:SetOperation(c22501.damop)
	c:RegisterEffect(e5)
end
function c22501.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c22501.filter(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c22501.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c22501.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c22501.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c22501.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c22501.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(tc:GetBaseAttack()/2)
		tc:RegisterEffect(e1)
	end
end
function c22501.regop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetLinkedGroup()
	if not g then return end
	local lg=g:Clone()
	lg:KeepAlive()
	e:SetLabelObject(lg)
end
function c22501.cfilter(c,g)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT) and g:IsContains(c)
end
function c22501.blcon(e,tp,eg,ep,ev,re,r,rp)
	local lg=e:GetLabelObject():GetLabelObject()
	if not lg then return false end
	return eg:IsExists(c22501.cfilter,1,nil,lg)
end
function c22501.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c22501.blop(e,tp,eg,ep,ev,re,r,rp)
	local lg=e:GetLabelObject():GetLabelObject()
	local tc=lg:GetFirst()
	local blood=0
	while tc do 
		blood=blood+tc:GetTextAttack()/2
		tc=lg:GetNext()
	end
	Duel.Recover(tp,blood,REASON_EFFECT)
end
function c22501.repfilter(c)
	return c:IsLocation(LOCATION_MZONE) and not c:IsStatus(STATUS_DESTROY_CONFIRMED)
end
function c22501.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local g=c:GetLinkedGroup()
		return not c:IsReason(REASON_REPLACE) and g:IsExists(c22501.repfilter,1,nil)
	end
	if Duel.SelectYesNo(tp,aux.Stringid(22501,2)) then
		local g=c:GetLinkedGroup()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
		local sg=g:FilterSelect(tp,c22501.repfilter,1,1,nil)
		Duel.SetTargetCard(sg)
		sg:GetFirst():SetStatus(STATUS_DESTROY_CONFIRMED,true)
		return true
	else return false end
end
function c22501.desrepop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	g:GetFirst():SetStatus(STATUS_DESTROY_CONFIRMED,false)
	Duel.Destroy(g,REASON_EFFECT+REASON_REPLACE)
end
function c22501.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local dam=math.abs(e:GetHandler():GetAttack()-e:GetHandler():GetBaseAttack())
	Duel.SetTargetPlayer(1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function c22501.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
		local dam=math.abs(e:GetHandler():GetAttack()-e:GetHandler():GetBaseAttack())
		Duel.Damage(p,dam,REASON_EFFECT)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(3000)
		c:RegisterEffect(e1)
	end
end
