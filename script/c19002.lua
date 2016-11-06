--融合贤者
require "expansions/script/nef/nef"
function c19002.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(19002,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c19002.target)
	e1:SetOperation(c19002.activate)
	c:RegisterEffect(e1)
	--print
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(19002,1))
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetTarget(c19002.pttg)
	e2:SetOperation(c19002.print)
	c:RegisterEffect(e2)
end
function c19002.filter(c)
	return (c:IsCode(24235) or c:IsCode(24094653)) and c:IsAbleToHand()
end
function c19002.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c19002.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c19002.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c19002.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c19002.pttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function c19002.print(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)==0 then return end
	local t = {
		[1] = {desc=aux.Stringid(19002,2),code=22131},
		[2] = {desc=aux.Stringid(19002,3),code=22132},
		[3] = {desc=aux.Stringid(19002,4),code=22133},
		[4] = {desc=aux.Stringid(19002,5),code=22134},
		[5] = {desc=aux.Stringid(19002,6),code=22135},
		[6] = {desc=aux.Stringid(19002,7),code=22161},
		[7] = {desc=aux.Stringid(19002,8),code=22162},
		[8] = {desc=aux.Stringid(19002,9),code=22191},
	}
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(19002,12))
	local sel=Duel.SelectOption(tp,Nef.unpackOneMember(t, "desc"))+1
	local code=t[sel].code
	local token=Duel.CreateToken(tp,code)
	Duel.MoveToField(token,tp,tp,LOCATION_SZONE,POS_FACEDOWN,true)
end
